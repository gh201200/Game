using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace TCPClient
{
    class Program
    {
        static Socket socket;
        static IPEndPoint adress;
        static ByteArray buffer;

        static void Main(string[] args)
        {
            buffer = new ByteArray(1024 * 1024 * 2);
            adress = new IPEndPoint(IPAddress.Parse("127.0.0.1"), 88);
            socket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
            socket.NoDelay = true;
            socket.BeginConnect(adress, ConnectCallback, null);
            while (true)
            {
                string str = Console.ReadLine();
                if (!string.IsNullOrEmpty(str))
                {
                    ByteArray msg = new ByteArray();
                    msg.WriteInt(1);
                    msg.WriteInt(1);
                    msg.WriteString(str);
                    Send(socket, msg);
                }
            }
        }

        static void ConnectCallback(IAsyncResult ar)
        {
            socket.EndConnect(ar);
            socket.BeginReceive(buffer.Buffer, buffer.EndIndex, buffer.Remain, SocketFlags.None, ReceiveCallback, null);
            UploadFile();
        }

        static void ReceiveCallback(IAsyncResult ar)
        {
            try
            {
                int len = socket.EndReceive(ar);
                //Console.WriteLine("----------------------------\nreceive count: " + len + "\n----------------------------");
                while (len > 4)
                {
                    int msgLen = BitConverter.ToInt32(buffer.Buffer, 0);
                    if (len - 4 >= msgLen)
                    {
                        ByteArray data = new ByteArray(buffer.GetData(4, msgLen));
                        HandleMessage(data);
                        buffer.MoveToHead(msgLen + 4, len - msgLen - 4);
                        len -= (msgLen + 4);
                    }
                }
                socket.BeginReceive(buffer.Buffer, buffer.EndIndex, buffer.Remain, SocketFlags.None, ReceiveCallback, null);
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
                socket.Close();
            }
        }

        static void HandleMessage(ByteArray data)
        {
            Console.WriteLine();
            Console.WriteLine("receive msg from server:");
            Console.WriteLine(data.ReadString());
            Console.WriteLine();
        }


        static void Send(Socket client, ByteArray data)
        {
            SocketAsyncEventArgs arg = new SocketAsyncEventArgs();
            arg.Completed += (arg1, arg2) =>
              {
                  Console.WriteLine("send length: " + arg2.Count);
              };
            byte[] lenArray = BitConverter.GetBytes(data.Data.Length);
            byte[] b = lenArray.Concat(data.Data).ToArray();
            arg.SetBuffer(b, 0, b.Length);
            client.SendAsync(arg);
        }

        static void UploadFile()
        {
            string path = "test.pdf";
            FileInfo info = new FileInfo(path);
            if (!info.Exists)
            {
                Console.WriteLine(info.FullName + " is not found!");
                return;
            }

            byte[] buffer = new byte[1024 * 1024];
            long curSize = 0;
            FileStream reader = info.OpenRead();

            try
            {
                while (true)
                {
                    ByteArray data = new ByteArray(1024 * 1024 * 2);
                    data.WriteInt((int)RequestCode.File);
                    data.WriteInt((int)ActionCode.UploadFile);

                    string fileName = path;
                    long totalSize = info.Length;
                    int blockSize = 1024 * 1024;
                    int len = reader.Read(buffer, 0, buffer.Length);
                    if (len <= 0) break;
                    data.WriteString(fileName);
                    data.WriteLong(totalSize);
                    data.WriteInt(blockSize);
                    data.WriteInt(len);
                    data.WriteBytes(buffer, 0, len);
                    Send(socket, data);
                    curSize += len;
                    ShowProgress(curSize / 1024f / 1024f, totalSize / 1024f / 1024f);
                    //Thread.Sleep(100);
                }
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
                reader.Close();
                socket.Close();
            }
        }

        static void ShowProgress(float cur, float total)
        {
            double progress = cur / total;
            progress = Math.Round(progress, 2);
            Console.WriteLine(progress * 100 + "%" + "    " + cur + "M/" + total + "M");
        }
    }
}
