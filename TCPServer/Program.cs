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
        static byte[] receiveBuffer = new byte[1024];
        static void Main(string[] args)
        {
            StartServerAsync();
        }

        static void StartServerAsync()
        {
            Socket serverSocket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
            Socket clientSocket = null;
            IPEndPoint ipEndPoint = new IPEndPoint(IPAddress.Parse("127.0.0.1"), 88);
            serverSocket.Bind(ipEndPoint);
            serverSocket.Listen(0);

            Console.WriteLine("server start listen, port is {0}", 88);

            clientSocket = serverSocket.Accept();

            string msg = "hello client ! 你好......";
            byte[] data = Encoding.UTF8.GetBytes(msg);
            clientSocket.Send(data);

            clientSocket.BeginReceive(receiveBuffer, 0, receiveBuffer.Length, SocketFlags.None, ReceiveCallback, clientSocket);

            Console.ReadKey();
        }

        static void ReceiveCallback(IAsyncResult ac)
        {
            Socket clientSocket = ac.AsyncState as Socket;
            int count = clientSocket.EndReceive(ac);
            string str = Encoding.UTF8.GetString(receiveBuffer, 0, count);
            Console.WriteLine("receive msg form {0} :\n{1}", ((IPEndPoint)clientSocket.RemoteEndPoint).Address, str);
            clientSocket.BeginReceive(receiveBuffer, 0, receiveBuffer.Length, SocketFlags.None, ReceiveCallback, clientSocket);
        }

        static void StartServerSync()
        {
            Socket serverSocket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
            Socket clientSocket = null;
            IPEndPoint ipEndPoint = new IPEndPoint(IPAddress.Parse("127.0.0.1"), 88);
            serverSocket.Bind(ipEndPoint);
            serverSocket.Listen(0);

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
