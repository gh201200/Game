using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TEST
{
    class Program
    {
        static void Main(string[] args)
        {
            byte[] data = new byte[1024];
            byte[] buff1 = Encoding.UTF8.GetBytes("中文English123 ");
            byte[] buff2 = BitConverter.GetBytes(0);
            data = buff1.Concat(buff2).ToArray();
            foreach (byte b in data)
            {
                Console.Write(b + ":");
            }
            Console.ReadKey();
        }
    }
}
