using System;
using System.IO;
using System.Net;
using System.Security.Cryptography;
using System.Text;

namespace Common
{
    public class Tools
    {
        #region MD5
        /// <summary>
        /// 计算字符串的MD5值
        /// </summary>
        public static string MD5(string source)
        {
            MD5CryptoServiceProvider md5 = new MD5CryptoServiceProvider();
            byte[] data = System.Text.Encoding.UTF8.GetBytes(source);
            byte[] md5Data = md5.ComputeHash(data, 0, data.Length);
            md5.Clear();

            string destString = "";
            for (int i = 0; i < md5Data.Length; i++)
            {
                destString += System.Convert.ToString(md5Data[i], 16).PadLeft(2, '0');
            }
            destString = destString.PadLeft(32, '0');
            return destString;
        }

        /// <summary>
        /// 计算文件的MD5值
        /// </summary>
        public static string MD5File(string file)
        {
            try
            {
                FileStream fs = new FileStream(file, FileMode.Open);
                System.Security.Cryptography.MD5 md5 = new System.Security.Cryptography.MD5CryptoServiceProvider();
                byte[] retVal = md5.ComputeHash(fs);
                fs.Close();

                StringBuilder sb = new StringBuilder();
                for (int i = 0; i < retVal.Length; i++)
                {
                    sb.Append(retVal[i].ToString("x2"));
                }
                return sb.ToString();
            }
            catch (Exception ex)
            {
                throw new Exception("md5file() fail, error:" + ex.Message);
            }
        }
        #endregion

        public static void ShowProgress(int curIndex, int totalIndex, long curSize, long totalSize, string title = "")
        {
            double progress = (double)curIndex / totalIndex;
            progress = Math.Round(progress, 2);
            double cs = Math.Round(curSize / 1024d / 1024d, 2);
            double ts = Math.Round(totalSize / 1024d / 1024d, 2);
            Console.WriteLine(title + "\t" + cs + "M/" + ts + "M" + "\n" + progress * 100 + "%" + "    " + curIndex + "/" + totalIndex);
        }

        public static string GetIpAdress()
        {
            string str = "";
            string hostName = Dns.GetHostName();
            IPHostEntry entry = Dns.GetHostEntry(hostName);
            foreach (var addr in entry.AddressList)
            {
                if (addr.AddressFamily == System.Net.Sockets.AddressFamily.InterNetwork)
                {
                    str = addr.ToString();
                    break;
                }
            }
            return str;
        }
    }
}
