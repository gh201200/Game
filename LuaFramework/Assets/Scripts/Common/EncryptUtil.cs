using UnityEngine;
using System.Security.Cryptography;
using System.IO;
using System.Text;

[SLua.CustomLuaClass]
public class EncryptUtil
{
    public static byte[] rgbIV = { 0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF };

    public static void EncryptFile(string inFile, string outFile, string passwd)
    {
        if (!File.Exists(inFile))
        {
            Debug.LogError(inFile + " is not found!");
            return;
        }

        string dirName = Path.GetDirectoryName(outFile);
        if (!string.IsNullOrEmpty(dirName)) if (!Directory.Exists(dirName)) Directory.CreateDirectory(dirName);

        using (FileStream fin = new FileStream(inFile, FileMode.Open))
        {
            using (FileStream fout = new FileStream(outFile, FileMode.Create))
            {
                using (CryptoStream cs = new CryptoStream(fout, GetEncryptoTransform(passwd), CryptoStreamMode.Write))
                {
                    byte[] data = new byte[1024 * 1024];
                    int len = 0;
                    while (true)
                    {
                        len = fin.Read(data, 0, data.Length);
                        if (len <= 0) break;
                        cs.Write(data, 0, len);
                    }
                }
            }
        }
    }

    public static void DecryptFile(string inFile, string outFile, string passwd)
    {
        if (!File.Exists(inFile))
        {
            Debug.LogError(inFile + " is not found!");
            return;
        }

        GameUtil.CreateDirectory(outFile);

        using (FileStream fin = new FileStream(inFile, FileMode.Open))
        {
            using (FileStream fout = new FileStream(outFile, FileMode.Create))
            {
                using (CryptoStream cs = new CryptoStream(fin, GetDecryptoTransform(passwd), CryptoStreamMode.Read))
                {
                    byte[] data = new byte[1024 * 1024];
                    int len = 0;
                    while (true)
                    {
                        len = cs.Read(data, 0, data.Length);
                        if (len <= 0) break;
                        fout.Write(data, 0, len);
                    }
                }
            }
        }
    }

    public static byte[] DecryptFileToBytes(string inFile, string passwd)
    {
        if (!File.Exists(inFile))
        {
            Debug.LogError(inFile + " is not found!");
            return null;
        }

        using (MemoryStream fout = new MemoryStream())
        {
            using (FileStream fin = new FileStream(inFile, FileMode.Open))
            {
                using (CryptoStream cs = new CryptoStream(fin, GetDecryptoTransform(passwd), CryptoStreamMode.Read))
                {
                    byte[] data = new byte[1024 * 1024];
                    int len = 0;
                    while (true)
                    {
                        len = cs.Read(data, 0, data.Length);
                        if (len <= 0) break;
                        fout.Write(data, 0, len);
                    }
                    return fout.ToArray();
                }
            }
        }
    }

    public static byte[] EncryptBytes(byte[] data, string passwd)
    {
        var ins = new MemoryStream(data);
        var outs = new MemoryStream();
        var cs = new CryptoStream(outs, GetEncryptoTransform(passwd), CryptoStreamMode.Write);
        var len = 0;
        var buffer = new byte[1024 * 512];
        while (true)
        {
            len = ins.Read(buffer, 0, buffer.Length);
            if (len <= 0) break;
            cs.Write(buffer, 0, len);
        }
        cs.Close();
        outs.Close();
        ins.Close();
        return outs.ToArray();
    }

    public static byte[] DecryptBytes(byte[] data, string passwd)
    {
        var ins = new MemoryStream(data);
        var outs = new MemoryStream();
        var cs = new CryptoStream(outs, GetDecryptoTransform(passwd), CryptoStreamMode.Write);
        var len = 0;
        var buffer = new byte[1024 * 512];
        while (true)
        {
            len = ins.Read(buffer, 0, buffer.Length);
            if (len <= 0) break;
            cs.Write(buffer, 0, len);
        }
        cs.Close();
        outs.Close();
        ins.Close();
        return outs.ToArray();
    }

    private static ICryptoTransform GetEncryptoTransform(string passwd)
    {
        DES des = new DESCryptoServiceProvider();
        while (passwd.Length < 8) passwd += "-";
        byte[] rgbKey = Encoding.UTF8.GetBytes(passwd.Substring(0, 8));
        ICryptoTransform trans = des.CreateEncryptor(rgbKey, rgbIV);
        return trans;
    }

    private static ICryptoTransform GetDecryptoTransform(string passwd)
    {
        DES des = new DESCryptoServiceProvider();
        while (passwd.Length < 8) passwd += "-";
        byte[] rgbKey = Encoding.UTF8.GetBytes(passwd.Substring(0, 8));
        ICryptoTransform trans = des.CreateDecryptor(rgbKey, rgbIV);
        return trans;
    }
}