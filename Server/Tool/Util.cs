using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Server.Tool
{
    public class Util
    {
        public static string GetClientKey(string ip, int port)
        {
            return ip + ":" + port;
        }
    }
}
