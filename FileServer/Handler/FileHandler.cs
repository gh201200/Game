using System;
using System.IO;
using FileServer.Controller;
using Common;
using System.Collections.Generic;
using System.Diagnostics;

namespace FileServer.Handler
{
    class FileHandler : IMessageHandle
    {
        private string assetRoot = "\\Assets";
        private string assetInfoName = "";

        public void Init()
        {
            NetManager.Instance.AddListener(OperationCode.UploadFile, UploadFile);
            NetManager.Instance.AddListener(OperationCode.CheckUpdate, CheckUpdate);
        }

        private void CheckUpdate(string adress, OperationCode oc, ByteArray msg)
        {
            string fileName = msg.ReadString();
            long totalSize = msg.ReadLong();
            int length = msg.ReadInt();
            long pos = msg.ReadLong();
            byte[] data = msg.ReadBytes();

            long curLength = 0;

            assetInfoName = fileName;

            FileInfo res = new FileInfo(fileName);
            if (res.Exists) res.Delete();

            FileInfo info = new FileInfo(fileName + ".record");

            ByteArray rep = new ByteArray(100);
            rep.WriteInt((int)oc);

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
                        OnCheckUpdateComplete(adress);
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
                        OnCheckUpdateComplete(adress);
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
                Tools.ShowProgress(info.Length, totalSize, "check update");
                Console.WriteLine(info.FullName);
            }
        }

        private void OnCheckUpdateComplete(string adress)
        {
            FileInfo info = new FileInfo(assetInfoName);
            HashSet<string> updateList = new HashSet<string>();
            HashSet<string> deleteList = new HashSet<string>();
        }

        private void UploadFile(string adress, OperationCode oc, ByteArray msg)
        {
            string fileName = msg.ReadString();
            long totalSize = msg.ReadLong();
            int len = msg.ReadInt();
            byte[] data = msg.ReadBytes();
            FileStream writer = new FileStream(fileName, FileMode.Append);
            if (writer.Length == totalSize)
            {
                Console.WriteLine("{0} is already complete!", fileName);
                writer.Close();
                return;
            }
            writer.Write(data, 0, len);
            ByteArray rep = new ByteArray(128);
            rep.WriteInt((int)oc);
            rep.WriteLong(writer.Length);
            rep.WriteString(fileName);
            NetManager.Instance.Send(adress, rep);
            Tools.ShowProgress(writer.Length, totalSize, "receiving file: " + fileName);
            writer.Close();
        }
    }
}
