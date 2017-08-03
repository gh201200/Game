using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Sockets;
using System.Reflection;
using Common;

namespace TcpServer.Controller
{
    public class NetManager
    {
        private static NetManager _instance;
        private static Dictionary<OperationType, Dictionary<OperationCode, List<Action<string, OperationType, OperationCode, ByteArray>>>> operationMap;

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
            operationMap = new Dictionary<OperationType, Dictionary<OperationCode, List<Action<string, OperationType, OperationCode, ByteArray>>>>();
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
            OperationType ot = (OperationType)msg.ReadInt();
            OperationCode oc = (OperationCode)msg.ReadInt();
            Console.WriteLine("handle message {0} {1}", ot.ToString(), oc.ToString());
            if (operationMap.ContainsKey(ot) && operationMap[ot].ContainsKey(oc) && operationMap[ot][oc].Count > 0)
            {
                foreach (var handler in operationMap[ot][oc])
                {
                    handler(client.IpAndPort, ot, oc, msg);
                }
            }
            else
            {
                Console.WriteLine("未处理的消息: {0}  {1}", ot, oc);
                return;
            }
        }

        public void AddListener(OperationType ot, OperationCode oc, Action<string, OperationType, OperationCode, ByteArray> handler)
        {
            if (!operationMap.ContainsKey(ot)) operationMap.Add(ot, new Dictionary<OperationCode, List<Action<string, OperationType, OperationCode, ByteArray>>>());
            if (!operationMap[ot].ContainsKey(oc)) operationMap[ot].Add(oc, new List<Action<string, OperationType, OperationCode, ByteArray>>());
            operationMap[ot][oc].Add(handler);
        }

        public void RemoveListener(OperationType ot, OperationCode oc)
        {
            if (operationMap.ContainsKey(ot) && operationMap[ot].ContainsKey(oc))
            {
                operationMap[ot].Remove(oc);
            }
            else
            {
                Console.WriteLine(oc + " is not contains in operationMap");
                return;
            }
        }

        public void RemoveListener(OperationType ot, OperationCode oc, Action<string, OperationType, OperationCode, ByteArray> handler)
        {
            if (operationMap.ContainsKey(ot) && operationMap[ot].ContainsKey(oc) && operationMap[ot][oc].Contains(handler))
            {
                operationMap[ot][oc].Remove(handler);
            }
            else
            {
                Console.WriteLine(handler + " is not contains in operationMap");
                return;
            }
        }
    }
}
