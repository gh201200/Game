﻿using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Sockets;
using Common;

namespace TCPClient
{
    class Program
    {
        private static Dictionary<OperationType, Dictionary<OperationCode, List<Action<OperationType, OperationCode, ByteArray>>>> operationMap;
        private static Socket socket;
        private static IPEndPoint adress;
        private static ByteArray receiveBuffer;
        private static Queue<string> uploadQue;
        private static bool uploading = false;
        private static int index = 0;
        private static int totalCount = 0;

        static void Main(string[] args)
        {
            operationMap = new Dictionary<OperationType, Dictionary<OperationCode, List<Action<OperationType, OperationCode, ByteArray>>>>();
            uploadQue = new Queue<string>();
            receiveBuffer = new ByteArray(1024 * 1024 * 2);
            adress = new IPEndPoint(IPAddress.Parse("192.168.0.102"), 88);
            socket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
            Init();
            socket.BeginConnect(adress, ConnectCallback, null);
            Console.ReadKey();
        }

        private static void Init()
        {
            AddListener(OperationType.Response, OperationCode.UploadFile, UploadFileResponse);
            AddListener(OperationType.Request, OperationCode.ShowMessage, ShowMessageRequest);
        }

        private static void ConnectCallback(IAsyncResult ar)
        {
            try
            {
                socket.EndConnect(ar);
                socket.BeginReceive(receiveBuffer.Buffer, receiveBuffer.EndIndex, receiveBuffer.Remain, SocketFlags.None, ReceiveCallback, null);
                //return;
                Console.WriteLine("正在上传文件");
                string[] files = Directory.GetFiles("PDF/", "*", SearchOption.AllDirectories);
                foreach (string f in files)
                {
                    uploadQue.Enqueue(f);
                }

                index = 0;
                totalCount = uploadQue.Count;

                while (true)
                {
                    if (uploadQue.Count <= 0)
                    {
                        Console.WriteLine("上传结束");
                        break;
                    }
                    if (!uploading)
                    {
                        index++;
                        uploading = true;
                        string name = uploadQue.Dequeue();
                        UploadFile(name);
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
            }
        }

        private static void ReceiveCallback(IAsyncResult ar)
        {
            try
            {
                int len = socket.EndReceive(ar);
                //Console.WriteLine("----------------------------\nreceive count: " + len + "\n----------------------------");
                receiveBuffer.AddEndIndex(len);
                len = receiveBuffer.Length;
                while (len > 4)
                {
                    int msgLen = BitConverter.ToInt32(receiveBuffer.Buffer, 0);
                    if (len - 4 >= msgLen)
                    {
                        ByteArray data = new ByteArray(receiveBuffer.GetData(4, msgLen));
                        HandleMessage(data);
                        receiveBuffer.MoveToHead(msgLen + 4, len - msgLen - 4);
                        len -= (msgLen + 4);
                    }
                    else break;
                }
                socket.BeginReceive(receiveBuffer.Buffer, receiveBuffer.EndIndex, receiveBuffer.Remain, SocketFlags.None, ReceiveCallback, null);
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
                socket.Close();
            }
        }

        private static void Send(Socket client, ByteArray data)
        {
            //SocketAsyncEventArgs arg = new SocketAsyncEventArgs();
            //arg.Completed += (arg1, arg2) =>
            //  {
            //      Console.WriteLine("send length: " + arg2.Count);
            //  };
            byte[] lenArray = BitConverter.GetBytes(data.Data.Length);
            byte[] b = lenArray.Concat(data.Data).ToArray();
            //arg.SetBuffer(b, 0, b.Length);
            //client.SendAsync(arg);
            client.Send(b);
        }

        private static void HandleMessage(ByteArray data)
        {
            OperationType ot = (OperationType)data.ReadInt();
            OperationCode oc = (OperationCode)data.ReadInt();
            if (operationMap.ContainsKey(ot) && operationMap[ot].ContainsKey(oc))
            {
                foreach (var handler in operationMap[ot][oc])
                {
                    handler(ot, oc, data);
                }
            }
            else
            {
                Console.WriteLine("未处理的消息: {0}  {1}", ot, oc);
                return;
            }
        }

        private static void ShowMessageRequest(OperationType ot, OperationCode oc, ByteArray data)
        {
            string msg = data.ReadString();
            Console.WriteLine(msg);
        }

        private static void UploadFile(string fileName, long seek = 0)
        {
            FileInfo info = new FileInfo(fileName);
            if (!info.Exists)
            {
                Console.WriteLine(info.FullName + " is not found!");
                return;
            }
            byte[] buffer = new byte[receiveBuffer.Buffer.Length - 1024];
            long totalSize = info.Length;

            if (totalSize == 0)
            {
                uploading = false;
                return;
            }

            FileStream reader = info.OpenRead();
            reader.Seek(seek, SeekOrigin.Begin);

            var length = reader.Read(buffer, 0, buffer.Length);
            if (length <= 0) return;
            ByteArray data = new ByteArray(buffer.Length + 1024);
            data.WriteInt((int)OperationType.Request);
            data.WriteInt((int)OperationCode.UploadFile);
            data.WriteString(fileName);
            data.WriteInt(index);
            data.WriteInt(totalCount);
            data.WriteLong(totalSize);
            data.WriteInt(length);
            data.WriteLong(reader.Position - length);
            data.WriteBytes(buffer, 0, length);
            Send(socket, data);
            reader.Close();
            seek += length;
            Tools.ShowProgress(index, totalCount, seek, totalSize, "正在上传: " + fileName);
        }

        private static void UploadFileResponse(OperationType ot, OperationCode oc, ByteArray data)
        {
            string fileName = data.ReadString();
            bool complete = data.ReadBool();
            long seek = data.ReadLong();
            //Thread.Sleep(100);
            if (!complete) UploadFile(fileName, seek);
            else
            {
                uploading = false;
            }
        }

        private static void AddListener(OperationType ot, OperationCode oc, Action<OperationType, OperationCode, ByteArray> handler)
        {
            if (!operationMap.ContainsKey(ot)) operationMap.Add(ot, new Dictionary<OperationCode, List<Action<OperationType, OperationCode, ByteArray>>>());
            if (!operationMap[ot].ContainsKey(oc)) operationMap[ot].Add(oc, new List<Action<OperationType, OperationCode, ByteArray>>());
            operationMap[ot][oc].Add(handler);
        }

        private static void RemoveListener(OperationType ot, OperationCode oc)
        {
            if (operationMap.ContainsKey(ot) && operationMap[ot].ContainsKey(oc))
            {
                operationMap[ot].Remove(oc);
            }
            else
            {
                Console.WriteLine(oc + " is not contains in operationMap");
                return;
            }
        }

        private static void RemoveListener(OperationType ot, OperationCode oc, Action<OperationType, OperationCode, ByteArray> handler)
        {
            if (operationMap.ContainsKey(ot) && operationMap[ot].ContainsKey(oc) && operationMap[ot][oc].Contains(handler))
            {
                operationMap[ot][oc].Remove(handler);
            }
            else
            {
                Console.WriteLine(handler + " is not contains in operationMap");
                return;
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
