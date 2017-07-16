using Server.Tool;
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
        static Message msg;
        static Socket clientSocket;

        static void Main(string[] args)
        {
            clientSocket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
            clientSocket.Connect(new IPEndPoint(IPAddress.Parse("127.0.0.1"), 88));

            if (!clientSocket.Connected)
            {
                Console.WriteLine("connect failed");
                Console.ReadKey();
                return;
            }
            msg = new Message();
            clientSocket.BeginReceive(msg.Buffer, msg.EndIndex, msg.Remain, SocketFlags.None, ReceiveCallback, null);

            //while (true)
            //{
            //    Console.WriteLine("enter a msg to send to server:");
            //    string msg = Console.ReadLine();
            //    if (msg == "q")
            //    {
            //        clientSocket.Close();
            //        return;
            //    }
            //    clientSocket.Send(Encoding.UTF8.GetBytes(msg));
            //}

            while (true)
            {
                string res = Console.ReadLine();
                if (res == "0")
                {
                    for (int i = 0; i < 1; i++)
                    {
                        Message _msg = new Message();
                        _msg.WriteInt(0);
                        _msg.WriteInt(0);
                        _msg.WriteString("this is a default message");
                        _msg.EndWrite();
                        clientSocket.Send(_msg.Buffer, _msg.EndIndex, SocketFlags.None);
                    }
                }
                if (res == "1")
                {
                    for (int i = 0; i < 1; i++)
                    {
                        Message _msg = new Message();
                        _msg.WriteInt(0);
                        _msg.WriteInt(1);
                        _msg.WriteString("this is a register message");
                        _msg.EndWrite();
                        clientSocket.Send(_msg.Buffer, _msg.EndIndex, SocketFlags.None);
                    }
                }
                if (res == "2")
                {
                    for (int i = 0; i < 1; i++)
                    {
                        Message _msg = new Message();
                        _msg.WriteInt(0);
                        _msg.WriteInt(2);
                        _msg.WriteString("this is a login message");
                        _msg.EndWrite();
                        clientSocket.Send(_msg.Buffer, _msg.EndIndex, SocketFlags.None);
                    }
                }
            }

            //StringBuilder sb = new StringBuilder();
            //for (int i = 0; i < 100; i++)
            //{
            //    sb.Append("message index " + i + "\n");
            //}
            //Message m = new Message();
            //m.WriteString(sb.ToString());
            //m.EndWrite();
            //clientSocket.Send(m.Buffer, m.EndIndex, 0);

            Console.ReadKey();
        }

        static void ReceiveCallback(IAsyncResult ar)
        {
            int amount = clientSocket.EndReceive(ar);
            msg.UpdateEndIndex(amount);
            while (msg.Check())
            {
                Console.WriteLine(msg.ReadInt());
                Console.WriteLine(msg.ReadBool());
                Console.WriteLine(msg.ReadString());
            }
            clientSocket.BeginReceive(msg.Buffer, msg.EndIndex, msg.Remain, SocketFlags.None, ReceiveCallback, null);
        }
    }
}
