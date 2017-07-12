using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading.Tasks;

namespace TCPServer
{
    class Program
    {
        public static int maxClient = 0;
        static void Main(string[] args)
        {
            Socket serverSocket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
            Socket clientSocket = null;
            IPEndPoint ipEndPoint = new IPEndPoint(IPAddress.Parse("127.0.0.1"), 88);
            serverSocket.Bind(ipEndPoint);
            serverSocket.Listen(maxClient);

            Console.WriteLine("server start listen, port is {0}", 88);

            clientSocket = serverSocket.Accept();

            string msg = "hello client ! 你好......";
            byte[] data = Encoding.UTF8.GetBytes(msg);
            clientSocket.Send(data);

            byte[] receiveBuffer = new byte[1024];
            int count = clientSocket.Receive(receiveBuffer);
            string receiveMsg = Encoding.UTF8.GetString(receiveBuffer, 0, count);
            Console.WriteLine("receive msg:\n" + receiveMsg);

            Console.ReadKey();
            clientSocket.Close();
            serverSocket.Close();
        }
    }
}
