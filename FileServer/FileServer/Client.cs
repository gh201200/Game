using FileServer.Common;
using FileServer.Controller;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading.Tasks;

namespace FileServer
{
    public class Client
    {
        public Socket Socket { get; private set; }

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

        private ByteArray buffer;

        public Client(Socket client)
        {
            this.Socket = client;
            this.Socket.NoDelay = true;
            this.buffer = new ByteArray(1024 * 1024 * 2);
            this.Socket.BeginReceive(buffer.Buffer, buffer.EndIndex, buffer.Remain, SocketFlags.None, ReceiveCallback, null);
            ByteArray data = new ByteArray(512);
            data.WriteString("hello client");
            NetManager.Instance.Send(this.Socket, data);
        }

        void ReceiveCallback(IAsyncResult ar)
        {
            try
            {
                int len = this.Socket.EndReceive(ar);
                Console.WriteLine("----------------------------\nreceive count: " + len + "\n----------------------------");
                while (len > 4)
                {
                    int msgLen = BitConverter.ToInt32(buffer.Buffer, 0);
                    if (len - 4 >= msgLen)
                    {
                        ByteArray msg = new ByteArray(buffer.GetData(4, msgLen));
                        NetManager.Instance.HandleMessage(this.Socket, msg);
                        buffer.MoveToHead(msgLen + 4, len - msgLen - 4);
                        len -= (msgLen + 4);
                    }
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
