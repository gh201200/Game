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
            IPEndPoint ipEndPoint = new IPEndPoint(IPAddress.Parse("127.0.0.1"), 88);
            serverSocket.Bind(ipEndPoint);
            serverSocket.Listen(0);

            Console.WriteLine("server start listen, port is {0}", 88);

            serverSocket.BeginAccept(AcceptAsync, serverSocket);

            Console.ReadKey();
        }

        /// <summary>
        /// 异步接收客户端连接回调
        /// </summary>
        /// <param name="ac"></param>
        static void AcceptAsync(IAsyncResult ac)
        {
            Socket serverSocket = ac.AsyncState as Socket;
            Socket clientSocket = serverSocket.EndAccept(ac);
            Console.WriteLine("new client form " + ((IPEndPoint)clientSocket.RemoteEndPoint).Address);
            //给客户端发送消息
            string msg = "hello client!";
            byte[] data = Encoding.UTF8.GetBytes(msg);
            clientSocket.Send(data);
            //接收客户端数据
            object[] args = new object[2];
            Message message = new Message();
            args[0] = clientSocket;
            args[1] = message;
            clientSocket.BeginReceive(message.Data, message.StartIndex, message.Remain, SocketFlags.None, ReceiveCallback, args);
            //监听客户端连接
            serverSocket.BeginAccept(AcceptAsync, serverSocket);
        }

        /// <summary>
        /// 异步接收客户端消息回调
        /// </summary>
        /// <param name="ac"></param>
        static void ReceiveCallback(IAsyncResult ac)
        {
            object[] args = ac.AsyncState as object[];
            Socket clientSocket = args[0] as Socket;
            Message message = args[1] as Message;
            try
            {
                int count = clientSocket.EndReceive(ac);
                if (count == 0)
                {
                    clientSocket.Close();
                    Console.WriteLine("a client disconnected!");
                    return;
                }
                message.ReadMessage(count);
                //string str = Encoding.UTF8.GetString(receiveBuffer, 0, count);
                //Console.WriteLine("receive msg form {0} :\n{1}", ((IPEndPoint)clientSocket.RemoteEndPoint).Address, str);
                clientSocket.BeginReceive(message.Data, message.StartIndex, message.Remain, SocketFlags.None, ReceiveCallback, args);
            }
            catch (Exception e)
            {
                clientSocket.Close();
                Console.WriteLine("a client disconnected!");
            }
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
