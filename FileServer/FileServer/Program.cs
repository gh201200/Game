using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FileServer.Common;
using System.Net.Sockets;
using System.Net;
using FileServer.Controller;

namespace FileServer
{
    class Program
    {
        static Socket server;
        static IPEndPoint endPoint;

        static void Main(string[] args)
        {
            endPoint = new IPEndPoint(IPAddress.Parse("127.0.0.1"), 88);
            server = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
            server.Bind(endPoint);
            server.Listen(0);

            Console.WriteLine("server start complete!\nListen: " + endPoint.Address + ":" + endPoint.Port);

            server.BeginAccept(ListenAsync, null);
            Console.ReadKey();
        }

        static void ListenAsync(IAsyncResult ar)
        {
            Socket socket = server.EndAccept(ar);
            Console.WriteLine("new client from: " + socket.RemoteEndPoint.ToString());
            Client client = new Client(socket);
            ClientManager.AddClient(socket.RemoteEndPoint.ToString(), client);
            server.BeginAccept(ListenAsync, null);
        }
    }
}
