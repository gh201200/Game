using FileServer.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Sockets;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace FileServer.Controller
{
    public abstract class ControllerBase
    {
        public abstract RequestCode RequestCode { get; }
    }
}
