using System;
using System.Net;
using System.Net.Sockets;
using Common;
//using MySql.Data.MySqlClient;
using TcpServer.Controller;

namespace TcpServer
{
    public class Client
    {
        public Socket Socket { get; private set; }

        //private MySqlConnection sqlCon = null;

        public string Ip
        {
            get
            {
                return ((IPEndPoint)Socket.RemoteEndPoint).Address.ToString();
            }
        }

        public int Port
        {
            get
            {
                return ((IPEndPoint)Socket.RemoteEndPoint).Port;
            }
        }

        public string IpAndPort
        {
            get
            {
                return Socket.RemoteEndPoint.ToString();
            }
        }

        private readonly ByteArray buffer;

        public Client(Socket client)
        {
            this.Socket = client;
            this.buffer = new ByteArray(Program.config.ReceiveLength_EachTime);
            //this.sqlCon = ConnHelper.Connect();
            this.Socket.BeginReceive(buffer.Buffer, buffer.EndIndex, buffer.Remain, SocketFlags.None, ReceiveCallback, null);
        }

        public void Close()
        {
            Socket?.Close();
            //if (sqlCon != null) ConnHelper.Close(sqlCon);
        }

        void ReceiveCallback(IAsyncResult ar)
        {
            try
            {
                int len = this.Socket.EndReceive(ar);
                buffer.AddEndIndex(len);
                len = buffer.Length;
                //Console.WriteLine("----------------------------\nreceive count: " + len + "\n----------------------------");
                while (len > 4)
                {
                    int msgLen = BitConverter.ToInt32(buffer.Buffer, 0);
                    if (len - 4 >= msgLen)
                    {
                        ByteArray msg = new ByteArray(buffer.GetData(4, msgLen));
                        NetManager.Instance.HandleMessage(this, msg);
                        buffer.MoveToHead(msgLen + 4, len - msgLen - 4);
                        len -= msgLen + 4;
                    }
                    else break;
                }
                this.Socket.BeginReceive(buffer.Buffer, buffer.EndIndex, buffer.Remain, SocketFlags.None, ReceiveCallback, null);
            }
            catch (Exception e)
            {
                Console.WriteLine(IpAndPort + " " + e.Message);
                ClientManager.RemoveClient(IpAndPort);
            }
        }
    }
}
