using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using Common;

namespace TCPClient
{
    class Program
    {
        static Socket socket;
        static IPEndPoint adress;
        static ByteArray buffer;
        private static string assetInfoPath;

        static void Main(string[] args)
        {
            buffer = new ByteArray(1024 * 1024 * 2);
            adress = new IPEndPoint(IPAddress.Parse("127.0.0.1"), 88);
            socket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
            socket.NoDelay = true;
            socket.BeginConnect(adress, ConnectCallback, null);
            Console.ReadKey();
        }

        static void ConnectCallback(IAsyncResult ar)
        {
            socket.EndConnect(ar);
            socket.BeginReceive(buffer.Buffer, buffer.EndIndex, buffer.Remain, SocketFlags.None, ReceiveCallback, null);

            assetInfoPath = Environment.CurrentDirectory;
            assetInfoPath = assetInfoPath.Substring(0, assetInfoPath.LastIndexOf('\\')) + "\\AssetsInfo.json";
            CheckUpdate(assetInfoPath);
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

        static void Send(Socket client, ByteArray data)
        {
            SocketAsyncEventArgs arg = new SocketAsyncEventArgs();
            //arg.Completed += (arg1, arg2) =>
            //  {
            //      Console.WriteLine("send length: " + arg2.Count);
            //  };
            byte[] lenArray = BitConverter.GetBytes(data.Data.Length);
            byte[] b = lenArray.Concat(data.Data).ToArray();
            arg.SetBuffer(b, 0, b.Length);
            client.SendAsync(arg);
        }

        static void HandleMessage(ByteArray data)
        {
            OperationCode oc = (OperationCode)data.ReadInt();
            if (oc == OperationCode.UploadFile)
            {
                UploadFileResponse(oc, data);
            }
            else if (oc == OperationCode.CheckUpdate)
            {
                CheckUpdateResponse(oc, data);
            }
        }

        private static void CheckUpdate(string fileName, long seek = 0)
        {
            FileInfo info = new FileInfo(fileName);
            if (!info.Exists)
            {
                Console.WriteLine(info.FullName + " is not found!");
                return;
            }
            byte[] buffer = new byte[100];
            long totalSize = info.Length;
            long curSize = 0;
            FileStream reader = info.OpenRead();
            reader.Seek(seek, SeekOrigin.Begin);

            var length = reader.Read(buffer, 0, buffer.Length);
            if (length <= 0) return;
            ByteArray data = new ByteArray(buffer.Length + 200);
            data.WriteInt((int)OperationCode.CheckUpdate);
            data.WriteString(Path.GetFileName(fileName));
            data.WriteLong(totalSize);
            data.WriteInt(length);
            data.WriteLong(reader.Position - length);
            data.WriteBytes(buffer, 0, length);
            Send(socket, data);
            curSize += length;
            reader.Close();
            Tools.ShowProgress(curSize, totalSize, "check update...");
        }

        private static void CheckUpdateResponse(OperationCode oc, ByteArray data)
        {
            bool complete = data.ReadBool();
            long seek = data.ReadLong();
            if (!complete) CheckUpdate(assetInfoPath, seek);
        }

        private static void UploadFileResponse(OperationCode oc, ByteArray data)
        {
            long length = data.ReadLong();
            string fileName = data.ReadString();
            UploadFile(fileName, length);
        }

        private static void UploadFile(string path, long seek = 0)
        {
            FileInfo info = new FileInfo(path);
            if (!info.Exists)
            {
                Console.WriteLine(info.FullName + " is not found!");
                return;
            }

            if (seek == info.Length)
            {
                return;
            }

            byte[] buffer = new byte[1024 * 1024];
            long curSize = seek;
            FileStream reader = info.OpenRead();
            reader.Seek(seek, SeekOrigin.Begin);

            try
            {
                ByteArray data = new ByteArray(1024 * 1024 * 2);
                data.WriteInt((int)OperationCode.UploadFile);

                string fileName = path;
                long totalSize = info.Length;
                int len = reader.Read(buffer, 0, buffer.Length);
                if (len <= 0) return;
                data.WriteString(fileName);
                data.WriteLong(totalSize);
                data.WriteInt(len);
                data.WriteBytes(buffer, 0, len);
                Send(socket, data);
                curSize += len;
                Tools.ShowProgress(curSize, totalSize, "send file: " + fileName);
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
                reader.Close();
                socket.Close();
            }
        }

        private static byte[] GetFileBytes(string fileName, long seek, int length)
        {
            FileInfo info = new FileInfo(fileName);
            if (!info.Exists)
            {
                Console.WriteLine(fileName + " is not found!");
                return null;
            }
            FileStream reader = info.OpenRead();
            reader.Seek(seek, SeekOrigin.Begin);
            var buffer = new byte[length];
            int len = reader.Read(buffer, 0, length);
            if (len <= 0)
            {
                Console.WriteLine(fileName + " read to end!");
                return null;
            }
            if (len >= length) return buffer;
            var data = new byte[len];
            Array.Copy(buffer, 0, data, 0, len);
            return data;
        }
    }
}
