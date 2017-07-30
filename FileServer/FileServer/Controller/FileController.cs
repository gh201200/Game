using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Sockets;
using System.Text;
using System.Threading.Tasks;
using FileServer.Common;
using System.IO;

namespace FileServer.Controller
{
    public class FileController : ControllerBase
    {
        public override RequestCode RequestCode
        {
            get
            {
                return RequestCode.File;
            }
        }

        private void CheckUpdateFile(Socket client, ByteArray msg)
        {
            string str = msg.ReadString();
            Console.WriteLine(str);
            ByteArray data = new ByteArray();
            data.WriteString(str);
            NetManager.Instance.Send(client, data);
        }

        private void UploadFile(Socket client, ByteArray msg)
        {
            string fileName = msg.ReadString();
            long totalSize = msg.ReadLong();
            int blockSize = msg.ReadInt();
            int realSize = msg.ReadInt();
            byte[] data = msg.ReadBytes();
            FileStream writer = new FileStream(fileName, FileMode.Append);
            writer.Write(data, 0, realSize);
            writer.Close();
        }
    }
}
