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
            byte[] buff1 = Encoding.UTF8.GetBytes("hello, world! 你好，世界！");
            byte[] buff2 = BitConverter.GetBytes(0);
            data = buff1.Concat(buff2).ToArray();
            Console.WriteLine(buff1.Length);
            foreach (byte b in buff1)
            {
                Console.Write(b + ":");
            }

            //bool l = true;
            //byte[] buff = BitConverter.GetBytes(l);
            //Console.WriteLine(buff.Length);
            Console.ReadKey();
        }
    }
}
