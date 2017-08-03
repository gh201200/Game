using Common;
using System;
using System.IO;
using System.Net;
using System.Net.Sockets;
using TcpServer.Controller;

namespace TcpServer
{
    class Program
    {
        public static Config config;
        private static Socket server;
        private static IPEndPoint endPoint;

        private static void Main(string[] args)
        {
            config = new Config("Config.json");
            if (!Directory.Exists(config.SaveDirectory)) Directory.CreateDirectory(config.SaveDirectory);
            Directory.SetCurrentDirectory(config.SaveDirectory);
            string ip = Tools.GetIpAdress();
            endPoint = new IPEndPoint(IPAddress.Parse(ip), config.Port);
            server = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
            server.Bind(endPoint);
            server.Listen(-1);

            Console.WriteLine("server start complete!\nListen: " + ip + ":" + endPoint.Port);

            NetManager.Instance.Init();

            server.BeginAccept(ListenAsync, null);
            Console.ReadKey();
        }

        private static void ListenAsync(IAsyncResult ar)
        {
            Socket socket = server.EndAccept(ar);
            if (ClientManager.GetClientMap().Count > 0)
            {
                ByteArray msg = new ByteArray(200);
                msg.WriteInt((int)OperationType.Request);
                msg.WriteInt((int)OperationCode.ShowMessage);
                msg.WriteString("服务器连接数达到上限，请稍后再试！");
                NetManager.Instance.Send(socket.RemoteEndPoint.ToString(), msg);
                socket.Close();
                server.BeginAccept(ListenAsync, null);
                return;
            }
            Console.WriteLine("new client from: " + socket.RemoteEndPoint);
            Client client = new Client(socket);
            ClientManager.AddClient(socket.RemoteEndPoint.ToString(), client);
            server.BeginAccept(ListenAsync, null);
        }
    }
}
