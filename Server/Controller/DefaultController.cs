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
        public override OperationCode RequestCode
        {
            get { return OperationCode.None; }
        }
    }
}
