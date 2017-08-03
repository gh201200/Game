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
            Directory.SetCurrentDirectory("..");
            string curDir = Directory.GetCurrentDirectory();
            Console.WriteLine(curDir);
            Console.ReadKey();
        }
    }
}
