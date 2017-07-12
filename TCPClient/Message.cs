using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCPClient
{
    class Message
    {
        public static byte[] GetBytes(string msg)
        {
            byte[] data = Encoding.UTF8.GetBytes(msg);
            byte[] lengthData = BitConverter.GetBytes(data.Length);
            byte[] newData = lengthData.Concat(data).ToArray();
            return newData;
        }
    }
}
