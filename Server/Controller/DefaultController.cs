using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Sockets;
using System.Text;
using System.Threading.Tasks;
using Common;
using Server.Server;
using Server.Tool;

namespace Server.Controller
{
    public class DefaultController : BaseController
    {
        public override RequestCode RequestCode
        {
            get { return RequestCode.None; }
        }

        public override void HandleMessage(ActionCode actionCode, Message msg, Socket clientSocket, Server.Server server)
        {
            Console.WriteLine("DefaultController Handle Message, ActionCode: " + actionCode);
            Console.WriteLine(msg.ReadString());
        }
    }
}
