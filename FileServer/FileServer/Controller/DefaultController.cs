using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Sockets;
using System.Text;
using System.Threading.Tasks;
using FileServer.Common;
using System.Reflection;

namespace FileServer.Controller
{
    public class DefaultController : ControllerBase
    {
        public override RequestCode RequestCode
        {
            get
            {
                return RequestCode.None;
            }
        }

        private void DefaultHandle(Socket client, ByteArray msg)
        {
            Console.WriteLine("DefaultHandle:");
            Console.WriteLine(msg.ReadString());
        }
    }
}
