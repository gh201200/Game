using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Globalization;
using System.Linq;
using System.Net.Sockets;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using Common;
using FileServer.Handler;

namespace FileServer.Controller
{
    public class NetManager
    {
        private static NetManager _instance;
        private Dictionary<OperationCode, List<Action<string, OperationCode, ByteArray>>> operationDict;

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
        }

        public void Init()
        {
            operationDict = new Dictionary<OperationCode, List<Action<string, OperationCode, ByteArray>>>();
            Assembly assembly = Assembly.GetExecutingAssembly();
            Type[] ts = assembly.GetTypes();
            foreach (Type t in ts)
            {

                if (typeof(IMessageHandle).IsAssignableFrom(t) && !t.IsInterface)
                {
                    Console.WriteLine("create IMessageHandle instance: " + t);
                    IMessageHandle handle = Activator.CreateInstance(t) as IMessageHandle;
                    handle?.Init();
                    Console.WriteLine(handle + " Init");
                }
            }
        }

        public void Send(string adress, ByteArray data)
        {
            SocketAsyncEventArgs arg = new SocketAsyncEventArgs();
            byte[] lenArray = BitConverter.GetBytes(data.Data.Length);
            byte[] b = lenArray.Concat(data.Data).ToArray();
            arg.SetBuffer(b, 0, b.Length);
            Client client = ClientManager.Get(adress);
            if (client == null)
            {
                Console.WriteLine(adress + " is not contains in client map");
                return;
            }
            client.Socket.SendAsync(arg);
        }

        public void HandleMessage(Client client, ByteArray msg)
        {
            OperationCode req = (OperationCode)msg.ReadInt();
            Console.WriteLine("handle message: " + req);
            List<Action<string, OperationCode, ByteArray>> list = null;
            operationDict.TryGetValue(req, out list);
            if (list == null || list.Count <= 0)
            {
                Console.WriteLine("no function to handle message: {0}", req);
                return;
            }
            foreach (var act in list)
            {
                if (act != null)
                {
                    act(client.IpAndPort, req, msg);
                }
            }
        }

        public void AddListener(OperationCode oc, Action<string, OperationCode, ByteArray> handle)
        {
            List<Action<string, OperationCode, ByteArray>> obj = null;
            operationDict.TryGetValue(oc, out obj);
            if (obj == null)
            {
                operationDict.Add(oc, new List<Action<string, OperationCode, ByteArray>>());
            }
            operationDict[oc].Add(handle);
        }

        public void RemoveListener(OperationCode oc)
        {
            operationDict[oc] = new List<Action<string, OperationCode, ByteArray>>();
        }
    }
}
