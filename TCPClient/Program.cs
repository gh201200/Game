using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading.Tasks;

namespace TCPClient
{
    class Program
    {
        static void Main(string[] args)
        {
            Socket clientSocket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
            clientSocket.Connect(new IPEndPoint(IPAddress.Parse("127.0.0.1"), 88));

            if (!clientSocket.Connected)
            {
                Console.WriteLine("connect failed");
                Console.ReadKey();
                return;
            }

            byte[] buffer = new byte[1024];
            int count = clientSocket.Receive(buffer);
            Console.WriteLine("receive msg:\n" + Encoding.UTF8.GetString(buffer, 0, count));

            while (true)
            {
                Console.WriteLine("enter a msg to send to server:");
                string msg = Console.ReadLine();
                if (msg == "q")
                {
                    clientSocket.Close();
                    return;
                }
                clientSocket.Send(Encoding.UTF8.GetBytes(msg));
            }
        }
    }
}
