using System;
using System.Text;

namespace Common
{
    public class ByteArray
    {
        private byte[] buffer;

        private int startIndex;

        private int endIndex;

        public int Length
        {
            get
            {
                return endIndex - startIndex;
            }
        }

        public int Remain
        {
            get
            {
                return buffer.Length - endIndex;
            }
        }

        public int StartIndex
        {
            get
            {
                return startIndex;
            }
        }

        public int EndIndex
        {
            get
            {
                return endIndex;
            }
        }

        /// <summary>
        /// 已写入的数据
        /// </summary>
        public byte[] Data
        {
            get
            {
                byte[] data = new byte[Length];
                Array.Copy(buffer, 0, data, 0, Length);
                return data;
            }
        }

        /// <summary>
        /// 字节数组
        /// </summary>
        public byte[] Buffer
        {
            get
            {
                return buffer;
            }
        }

        public ByteArray()
        {
            buffer = new byte[2048];
            Init();
        }

        public ByteArray(int length)
        {
            buffer = new byte[length];
            Init();
        }

        public ByteArray(long length)
        {
            buffer = new byte[length];
            Init();
        }

        public ByteArray(byte[] data)
        {
            buffer = new byte[data.Length];
            SetData(data, 0, data.Length);
        }

        public ByteArray(byte[] data, int offset, int length)
        {
            buffer = new byte[length];
            SetData(data, offset, length);
        }

        public byte[] GetData(int offset, int length)
        {
            byte[] res = new byte[length];
            Array.Copy(buffer, offset, res, 0, length);
            return res;
        }

        /// <summary>
        /// 将offset位置开始的length长度的字节移动到数组开头
        /// </summary>
        /// <param name="offset"></param>
        public void MoveToHead(int offset, int length)
        {
            Array.Copy(buffer, offset, buffer, 0, length);
            startIndex = 0;
            endIndex = length;
        }

        public void AddEndIndex(int count)
        {
            endIndex += count;
        }

        private void SetData(byte[] data, int offset, int length)
        {
            Array.Copy(data, offset, buffer, 0, length);
            startIndex = 0;
            endIndex = length;
        }

        public void WriteBool(bool value)
        {
            byte[] data = BitConverter.GetBytes(value);
            Array.Copy(data, 0, buffer, endIndex, data.Length);
            endIndex += data.Length;
        }

        /// <summary>
        /// 0-255
        /// </summary>
        /// <param name="value"></param>
        public void WriteByte(byte value)
        {
            buffer[endIndex++] = value;
        }

        /// <summary>
        /// -128-127
        /// </summary>
        /// <param name="value"></param>
        public void WriteSByte(sbyte value)
        {
            byte sb = value > 127 ? (byte)(value - 256) : (byte)value;
            buffer[endIndex++] = sb;
        }

        /// <summary>
        /// 表示 1 个 Unicode 字符
        /// </summary>
        /// <param name="value"></param>
        public void WriteChar(char value)
        {
            byte[] data = BitConverter.GetBytes(value);
            Array.Copy(data, 0, buffer, endIndex, data.Length);
            endIndex += data.Length;
        }

        /// <summary>
        /// -32,768-32,767
        /// </summary>
        /// <param name="value"></param>
        public void WriteShort(short value)
        {
            byte[] data = BitConverter.GetBytes(value);
            Array.Copy(data, 0, buffer, endIndex, data.Length);
            endIndex += data.Length;
        }

        /// <summary>
        /// 0-65,535
        /// </summary>
        /// <param name="value"></param>
        public void WriteUShort(ushort value)
        {
            byte[] data = BitConverter.GetBytes(value);
            Array.Copy(data, 0, buffer, endIndex, data.Length);
            endIndex += data.Length;
        }

        /// <summary>
        /// -2147483648-2147483647
        /// </summary>
        /// <param name="value"></param>
        public void WriteInt(int value)
        {
            byte[] data = BitConverter.GetBytes(value);
            Array.Copy(data, 0, buffer, endIndex, data.Length);
            endIndex += data.Length;
        }

        /// <summary>
        ///  0-4294967295
        /// </summary>
        /// <param name="value"></param>
        public void WriteUInt(uint value)
        {
            byte[] data = BitConverter.GetBytes(value);
            Array.Copy(data, 0, buffer, endIndex, data.Length);
            endIndex += data.Length;
        }

        /// <summary>
        /// 带符号长整型
        /// </summary>
        /// <param name="value"></param>
        public void WriteLong(long value)
        {
            byte[] data = BitConverter.GetBytes(value);
            Array.Copy(data, 0, buffer, endIndex, data.Length);
            endIndex += data.Length;
        }

        /// <summary>
        /// 无符号长整型
        /// </summary>
        /// <param name="value"></param>
        public void WriteULong(long value)
        {
            byte[] data = BitConverter.GetBytes(value);
            Array.Copy(data, 0, buffer, endIndex, data.Length);
            endIndex += data.Length;
        }

        /// <summary>
        /// 单精度浮点型
        /// </summary>
        /// <param name="value"></param>
        public void WriteFloat(float value)
        {
            byte[] data = BitConverter.GetBytes(value);
            Array.Copy(data, 0, buffer, endIndex, data.Length);
            endIndex += data.Length;
        }

        /// <summary>
        /// 双精度浮点型
        /// </summary>
        /// <param name="value"></param>
        public void WriteDouble(double value)
        {
            byte[] data = BitConverter.GetBytes(value);
            Array.Copy(data, 0, buffer, endIndex, data.Length);
            endIndex += data.Length;
        }

        public void WriteString(string value)
        {
            byte[] data = Encoding.UTF8.GetBytes(value);
            int len = data.Length;
            WriteInt(len);
            Array.Copy(data, 0, buffer, endIndex, len);
            endIndex += len;
        }

        public void WriteBytes(byte[] data)
        {
            WriteBytes(data, 0, data.Length);
        }

        public void WriteBytes(byte[] data, int offset, int length)
        {
            WriteInt(length);
            Array.Copy(data, offset, buffer, endIndex, length);
            endIndex += length;
        }

        public bool ReadBool()
        {
            bool res = BitConverter.ToBoolean(buffer, startIndex);
            startIndex += 1;
            return res;
        }

        public byte ReadByte()
        {
            byte res = buffer[startIndex++];
            return res;
        }

        public sbyte ReadSByte()
        {
            sbyte res;
            if (buffer[startIndex] > 127)
                res = (sbyte)(buffer[startIndex++] - 256);
            else
                res = (sbyte)(buffer[startIndex++]);
            return res;
        }

        public char ReadChar()
        {
            char res = BitConverter.ToChar(buffer, startIndex);
            startIndex += 2;
            return res;
        }

        public short ReadShort()
        {
            short res = BitConverter.ToInt16(buffer, startIndex);
            startIndex += 2;
            return res;
        }

        public ushort ReadUShort()
        {
            ushort res = BitConverter.ToUInt16(buffer, startIndex);
            startIndex += 2;
            return res;
        }

        public int ReadInt()
        {
            var res = BitConverter.ToInt32(buffer, startIndex);
            startIndex += 4;
            return res;
        }

        public uint ReadUInt()
        {
            var res = BitConverter.ToUInt32(buffer, startIndex);
            startIndex += 4;
            return res;
        }

        public long ReadLong()
        {
            var res = BitConverter.ToInt64(buffer, startIndex);
            startIndex += 8;
            return res;
        }

        public ulong ReadULong()
        {
            var res = BitConverter.ToUInt64(buffer, startIndex);
            startIndex += 8;
            return res;
        }

        public float ReadFloat()
        {
            var res = BitConverter.ToSingle(buffer, startIndex);
            startIndex += 4;
            return res;
        }

        public double ReadDouble()
        {
            var res = BitConverter.ToDouble(buffer, startIndex);
            startIndex += 8;
            return res;
        }

        public string ReadString()
        {
            int len = ReadInt();
            var res = Encoding.UTF8.GetString(buffer, startIndex, len);
            startIndex += len;
            return res;
        }

        public byte[] ReadBytes()
        {
            int len = ReadInt();
            byte[] data = new byte[len];
            Array.Copy(buffer, startIndex, data, 0, len);
            startIndex += len;
            return data;
        }

        public void Init()
        {
            startIndex = 0;
            endIndex = 0;
        }
    }
}
