using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading.Tasks;
using Server.Controller;
using Server.Tool;

namespace Server.Server
{
    public class Server
    {
        private IPEndPoint ipEndPoint;
        private Socket serverSocket;
        private Dictionary<string, Client> clientDict;

        public Server()
        {
        }

        public Server(string ip, int port)
        {
            SetIpAndPort(ip, port);
        }

        public void SetIpAndPort(string ip, int port)
        {
            ipEndPoint = new IPEndPoint(IPAddress.Parse(ip), port);
        }

        public void Start()
        {
            serverSocket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
            serverSocket.Bind(ipEndPoint);
            serverSocket.Listen(0);
            serverSocket.BeginAccept(AcceptAsyncCallback, null);
            clientDict = new Dictionary<string, Client>();
            Console.WriteLine("server start complete!");
        }

        private void AcceptAsyncCallback(IAsyncResult ar)
        {
            Socket clientSocket = serverSocket.EndAccept(ar);
            Client client = new Client(clientSocket, this);
            client.Start();
            serverSocket.BeginAccept(AcceptAsyncCallback, null);
            string ip = ((IPEndPoint)clientSocket.RemoteEndPoint).Address.ToString();
            int port = ((IPEndPoint)clientSocket.RemoteEndPoint).Port;
            string key = Util.GetClientKey(ip, port);
            Console.WriteLine("new client from {0}:{1}", ip, port);
            lock (clientDict)
            {
                if (!clientDict.ContainsKey(key))
                {
                    clientDict.Add(key, client);
                }
                else
                {
                    throw (new Exception("connect client is already contains!"));
                }
            }
        }

        public void RemoveClient(string key)
        {
            lock (clientDict)
            {
                if (clientDict.ContainsKey(key))
                {
                    clientDict.Remove(key);
                }
                else
                {
                    throw (new Exception(string.Format("the client you want to remove is not contains in clientDic! ip is {0}", key)));
                }
            }
        }
    }
}
