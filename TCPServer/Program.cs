using Common;
using System;
using System.Net;
using System.Net.Sockets;
using TcpServer.Controller;

namespace TcpServer
{
    class Program
    {
        static Socket server;
        static IPEndPoint endPoint;

        static void Main(string[] args)
        {
            string ip = Tools.GetIpAdress();
            endPoint = new IPEndPoint(IPAddress.Parse(ip), 88);
            server = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
            server.Bind(endPoint);
            server.Listen(1);

            Console.WriteLine("server start complete!\nListen: " + ip + ":" + endPoint.Port);

            NetManager.Instance.Init();

            server.BeginAccept(ListenAsync, null);
            Console.ReadKey();
        }

        static void ListenAsync(IAsyncResult ar)
        {
            Socket socket = server.EndAccept(ar);
            if (ClientManager.GetClientMap().Count > 0)
            {

            }
            Console.WriteLine("new client from: " + socket.RemoteEndPoint);
            Client client = new Client(socket);
            ClientManager.AddClient(socket.RemoteEndPoint.ToString(), client);
            server.BeginAccept(ListenAsync, null);
        }
    }
}
