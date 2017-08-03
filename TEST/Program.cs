using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace TEST
{
    class Program
    {
        static void Main(string[] args)
        {
            string str = "";
            string hostName = Dns.GetHostName();
            IPHostEntry entry = Dns.GetHostEntry(hostName);
            foreach (var addr in entry.AddressList)
            {
                //if (addr.AddressFamily == System.Net.Sockets.AddressFamily.InterNetwork)
                //{
                //}
                str = addr.ToString();
                Console.WriteLine(addr.AddressFamily + " " + str);
            }
            Console.ReadKey();
        }
    }
}
