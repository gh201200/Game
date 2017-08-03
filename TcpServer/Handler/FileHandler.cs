using System;
using System.Collections.Generic;
using System.IO;
using Common;
using TcpServer.Controller;

namespace TcpServer.Handler
{
    class FileHandler : IMessageHandle
    {
        private string assetRoot = "\\Assets";
        private string assetInfoName = "";

        public void Init()
        {
            NetManager.Instance.AddListener(OperationType.Request, OperationCode.UploadFile, UploadFile);
            NetManager.Instance.AddListener(OperationType.Request, OperationCode.CleanFiles, CleanFilesRequest);
        }

        private void UploadFile(string adress, OperationType ot, OperationCode oc, ByteArray msg)
        {
            string fileName = msg.ReadString();
            int curIndex = msg.ReadInt();
            int totalIndex = msg.ReadInt();
            long totalSize = msg.ReadLong();
            int length = msg.ReadInt();
            long pos = msg.ReadLong();
            byte[] data = msg.ReadBytes();

            long curLength = 0;

            assetInfoName = fileName;

            string dir = Path.GetDirectoryName(fileName);
            if (!string.IsNullOrEmpty(dir))
            {
                if (!Directory.Exists(dir)) Directory.CreateDirectory(dir);
            }

            FileInfo res = new FileInfo(fileName);
            if (res.Exists) res.Delete();

            FileInfo info = new FileInfo(fileName + ".record");

            ByteArray rep = new ByteArray(1024);
            rep.WriteInt((int)OperationType.Response);
            rep.WriteInt((int)oc);
            rep.WriteString(fileName);

            if (info.Exists)
            {
                if (info.Length == pos)
                {
                    FileStream writer = new FileStream(fileName + ".record", FileMode.Append);
                    writer.Write(data, 0, length);
                    curLength = writer.Length;
                    writer.Close();

                    if (curLength == totalSize)
                    {
                        rep.WriteBool(true);
                        if (File.Exists(fileName)) File.Delete(fileName);
                        info.MoveTo(fileName);
                    }
                    else rep.WriteBool(false);

                    rep.WriteLong(curLength);
                }
                else
                {
                    if (info.Length == totalSize)
                    {
                        rep.WriteBool(true);
                        if (File.Exists(fileName)) File.Delete(fileName);
                        info.MoveTo(fileName);
                    }
                    else
                    {
                        rep.WriteBool(false);
                    }
                    rep.WriteLong(info.Length);
                }
            }
            else
            {
                if (pos == 0)
                {
                    FileStream writer = new FileStream(fileName + ".record", FileMode.Append);
                    writer.Write(data, 0, length);
                    curLength = writer.Length;
                    writer.Close();
                    if (curLength == totalSize)
                    {
                        rep.WriteBool(true);
                        if (File.Exists(fileName)) File.Delete(fileName);
                        info.MoveTo(fileName);
                    }
                    else rep.WriteBool(false);

                    rep.WriteLong(curLength);
                }
                else
                {
                    rep.WriteBool(false);
                    rep.WriteLong(0);
                }
            }
            NetManager.Instance.Send(adress, rep);
            if (info.Exists)
            {
                Tools.ShowProgress(curIndex, totalIndex, info.Length, totalSize, "接收文件: " + fileName);
                if (curIndex == totalIndex) Console.WriteLine("接收结束");
            }
        }

        private void CleanFilesRequest(string adress, OperationType ot, OperationCode oc, ByteArray msg)
        {
            Console.WriteLine("clean directory: " + Program.config.SaveDirectory);
            DirectoryInfo di = new DirectoryInfo(Program.config.SaveDirectory);
            foreach (var info in di.GetDirectories()) info.Delete(true);
            foreach (var info in di.GetFiles()) info.Delete();
            bool success = !(di.GetFiles("*", SearchOption.AllDirectories).Length > 0);
            ByteArray data = new ByteArray(50);
            data.WriteInt((int)OperationType.Response);
            data.WriteInt((int)OperationCode.CleanFiles);
            data.WriteBool(success);
            NetManager.Instance.Send(adress, data);
        }
    }
}
