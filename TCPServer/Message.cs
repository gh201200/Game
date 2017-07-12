using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCPServer
{
    class Message
    {
        private byte[] data = new byte[1024];
        private int startIndex = 0;

        public byte[] Data
        {
            get { return data; }
        }

        public int StartIndex
        {
            get { return startIndex; }
        }

        public int Remain
        {
            get { return data.Length - startIndex; }
        }

        public void ReadMessage(int count)
        {
            startIndex += count;
            while (true)
            {
                if (startIndex <= 4) return;
                int length = BitConverter.ToInt32(data, 0);
                if (startIndex - 4 < length) return;
                string msg = Encoding.UTF8.GetString(data, 4, length);
                Console.WriteLine("receive message: " + msg);
                Array.Copy(data, length + 4, data, 0, startIndex - length - 4);
                startIndex -= (length + 4);
            }
        }
    }
}
