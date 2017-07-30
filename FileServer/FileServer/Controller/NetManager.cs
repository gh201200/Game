using FileServer.Common;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Net.Sockets;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace FileServer.Controller
{
    public class NetManager
    {
        private static NetManager _instance;
        private Dictionary<RequestCode, ControllerBase> controllerDic;

        public static NetManager Instance
        {
            get
            {
                if (_instance == null) _instance = new NetManager();
                return _instance;
            }
        }

        public NetManager()
        {
            Init();
        }

        private void Init()
        {
            controllerDic = new Dictionary<RequestCode, ControllerBase>();
            Assembly assembly = Assembly.GetExecutingAssembly();
            Type[] ts = assembly.GetTypes();
            foreach (Type t in ts)
            {
                if (t.IsSubclassOf(typeof(ControllerBase)))
                {
                    ControllerBase co = Activator.CreateInstance(t) as ControllerBase;
                    if (!controllerDic.ContainsKey(co.RequestCode))
                    {
                        controllerDic.Add(co.RequestCode, co);
                        Console.WriteLine("controller: " + co);
                    }
                }
            }
        }

        public ControllerBase GetController(RequestCode requestCode)
        {
            return controllerDic[requestCode];
        }

        public void Send(Socket client, ByteArray data)
        {
            SocketAsyncEventArgs arg = new SocketAsyncEventArgs();
            byte[] lenArray = BitConverter.GetBytes(data.Data.Length);
            byte[] b = lenArray.Concat(data.Data).ToArray();
            arg.SetBuffer(b, 0, b.Length);
            client.SendAsync(arg);
        }

        public void HandleMessage(Socket client, ByteArray msg)
        {
            RequestCode req = (RequestCode)msg.ReadInt();
            ActionCode act = (ActionCode)msg.ReadInt();
            Console.WriteLine("handle message: " + req + " - " + act);
            ControllerBase cb = GetController(req);
            if (cb == null)
            {
                Console.WriteLine("controller is not found! RequestCode = " + req);
                return;
            }
            Type obj = cb.GetType();
            string methodName = "DefaultHandle";
            if (act != ActionCode.None) methodName = act.ToString();
            MethodInfo info = obj.GetMethod(methodName, BindingFlags.Instance | BindingFlags.NonPublic);
            if (info == null)
            {
                Console.WriteLine("method {0} is not found in {1}", methodName, cb);
                return;
            }
            info.Invoke(cb, new object[] { client, msg });
        }
    }
}
