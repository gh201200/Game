using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Server.Tool
{
    public class Message
    {
        private byte[] buffer;
        private int startIndex;
        private int endIndex;
        private int msgLength;

        public Message()
        {
            buffer = new byte[2048];
            startIndex = 0;
            endIndex = 0;
        }

        public Message(int startIndex, int endIndex, byte[] buffer)
        {
            this.startIndex = startIndex;
            this.endIndex = endIndex;
            this.buffer = buffer;
        }

        public Message New()
        {
            byte[] data = new byte[Length];
            Array.Copy(buffer, startIndex, data, 0, Length);
            Message m = new Message(0, Length, data);
            return m;
        }

        public int StartIndex
        {
            get { return startIndex; }
        }

        public int EndIndex
        {
            get { return endIndex; }
        }

        public byte[] Buffer
        {
            get { return buffer; }
        }

        /// <summary>
        /// 剩余可存储空间
        /// </summary>
        public int Remain
        {
            get { return buffer.Length - endIndex; }
        }

        /// <summary>
        /// 数据长度
        /// </summary>
        public int Length
        {
            get { return endIndex - startIndex; }
        }

        public void UpdateEndIndex(int amount)
        {
            endIndex += amount;
        }

        /// <summary>
        /// 检测消息是否完整
        /// </summary>
        /// <returns></returns>
        public bool Check()
        {
            if (Length <= 4) return false;
            msgLength = BitConverter.ToInt32(buffer, startIndex);
            if (Length >= msgLength)
            {
                //覆盖已经读取过的字节位置
                Array.Copy(buffer, startIndex, buffer, 0, Length);
                int len = Length;
                startIndex = 0;
                endIndex = len;
                //开始4个字节为消息长度
                startIndex += 4;
            }
            //Console.WriteLine("check res -> startIndex:{0} msgLength:{1} Length:{2}", startIndex, msgLength, Length);
            return Length >= msgLength;
        }

        /// <summary>
        /// 写入结束后在消息头添加4个字节的消息长度
        /// </summary>
        public void EndWrite()
        {
            byte[] data = BitConverter.GetBytes(Length);
            Array.Copy(buffer, 0, buffer, 4, Length);
            Array.Copy(data, 0, buffer, 0, 4);
            endIndex += 4;
        }

        #region Read
        public long ReadLong()
        {
            long res = BitConverter.ToInt64(buffer, startIndex);
            startIndex += 8;
            return res;
        }

        public int ReadInt()
        {
            int res = BitConverter.ToInt32(buffer, startIndex);
            startIndex += 4;
            return res;
        }

        public short ReadShort()
        {
            short res = BitConverter.ToInt16(buffer, startIndex);
            startIndex += 2;
            return res;
        }

        public double ReadDouble()
        {
            double res = BitConverter.ToDouble(buffer, startIndex);
            startIndex += 8;
            return res;
        }

        public float ReadFloat()
        {
            float res = BitConverter.ToSingle(buffer, startIndex);
            startIndex += 4;
            return res;
        }

        public byte[] ReadBytes()
        {
            int length = ReadInt();
            byte[] res = new byte[length];
            Array.Copy(buffer, StartIndex, res, 0, length);
            startIndex += length;
            return res;
        }

        public bool ReadBool()
        {
            bool res = BitConverter.ToBoolean(buffer, StartIndex);
            startIndex += 1;
            return res;
        }

        public string ReadString()
        {
            int length = BitConverter.ToInt32(buffer, startIndex);
            startIndex += 4;
            string res = Encoding.UTF8.GetString(buffer, startIndex, length);
            startIndex += length;
            return res;
        }
        #endregion

        #region Write
        public void WriteLong(long l)
        {
            byte[] data = new byte[8];
            data = BitConverter.GetBytes(l);
            Array.Copy(data, 0, buffer, endIndex, 8);
            endIndex += 8;
        }

        public void WriteInt(int i)
        {
            byte[] data = new byte[4];
            data = BitConverter.GetBytes(i);
            Array.Copy(data, 0, buffer, endIndex, 4);
            endIndex += 4;
        }

        public void WriteShort(short s)
        {
            byte[] data = new byte[2];
            data = BitConverter.GetBytes(s);
            Array.Copy(data, 0, buffer, endIndex, 2);
            endIndex += 2;
        }

        public void WriteDouble(double d)
        {
            byte[] data = new byte[8];
            data = BitConverter.GetBytes(d);
            Array.Copy(data, 0, buffer, endIndex, 8);
            endIndex += 8;
        }

        public void WriteFloat(float f)
        {
            byte[] data = new byte[4];
            data = BitConverter.GetBytes(f);
            Array.Copy(data, 0, buffer, endIndex, 4);
            endIndex += 4;
        }

        public void WriteBytes(byte[] data)
        {
            int count = data.Length;
            WriteInt(count);
            Array.Copy(data, 0, buffer, endIndex, data.Length);
            endIndex += data.Length;
        }

        public void WriteBool(bool bo)
        {
            byte[] b = BitConverter.GetBytes(bo);
            Array.Copy(b, 0, buffer, endIndex, b.Length);
            endIndex += b.Length;
        }

        public void WriteString(string str)
        {
            byte[] strArray = Encoding.UTF8.GetBytes(str);
            int strLen = strArray.Length;
            WriteInt(strLen);
            Array.Copy(strArray, 0, buffer, endIndex, strLen);
            endIndex += strLen;
        }
        #endregion
    }
}
