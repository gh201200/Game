using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Common;
using Server.Server;
using System.Net.Sockets;
using Server.Tool;

namespace Server.Controller
{
    public abstract class BaseController
    {
        public abstract RequestCode RequestCode
        {
            get;
        }

        public abstract void HandleMessage(ActionCode actionCode, Message msg, Socket clientSocket, Server.Server server);
    }
}
