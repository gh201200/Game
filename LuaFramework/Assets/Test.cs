using System;
using UnityEngine;
using System.Diagnostics;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using Debug = UnityEngine.Debug;

public class Test : MonoBehaviour
{
    private static byte[] desIv = new byte[] { 0xF, 0x56, 0x52, 0xCD, 0xFF, 0x3F, 0x5D, 0x4 };

    void Start()
    {
        string str = "hello world!";
        var passwd = "1993";

        var bytes = Api.GetBytes(str);
        var res = Api.GetString(bytes);
        var ebytes = EncryptUtil.EncryptBytes(bytes, passwd);
        var dbytes = EncryptUtil.DecryptBytes(ebytes, passwd);

        str = Api.GetString(dbytes);
    }

    /// <summary>  
    /// 对字节数组进行加密  
    /// </summary>  
    /// <param name="srcBs">需要加密的字节数组对象</param>  
    /// <param name="key"></param>  
    /// <returns>返回加密过的字节数组</returns>  
    public static byte[] EncryptBytes(byte[] srcBs, string key)
    {
        string desKeyStr = key;
        while (desKeyStr.Length < 8) desKeyStr += "-";
        byte[] desKey = System.Text.Encoding.UTF8.GetBytes(desKeyStr.Substring(0, 8));

        MemoryStream ins = new MemoryStream(srcBs);
        MemoryStream outs = new MemoryStream();
        outs.SetLength(0);

        byte[] buffer = new byte[1024 * 512];
        long readLen = 0;
        long totlen = ins.Length;
        int len;

        DES des = new DESCryptoServiceProvider();
        CryptoStream encStream = new CryptoStream(outs, des.CreateEncryptor(desKey, desIv), CryptoStreamMode.Write);

        while (readLen < totlen)
        {
            len = ins.Read(buffer, 0, buffer.Length);
            encStream.Write(buffer, 0, len);
            readLen += len;
        }
        encStream.Close();
        outs.Close();
        ins.Close();

        return outs.ToArray();

    }

    /// <summary>  
    /// 解密字节数组  
    /// </summary>  
    /// <param name="srcBs"></param>  
    /// <param name="key"></param>  
    /// <returns></returns>  
    public static byte[] DecryptBytes(byte[] srcBs, string key)
    {
        string desKeyStr = key;
        while (desKeyStr.Length < 8) desKeyStr += "-";
        byte[] desKey = System.Text.Encoding.UTF8.GetBytes(desKeyStr.Substring(0, 8));

        MemoryStream ins = new MemoryStream(srcBs);
        MemoryStream outs = new MemoryStream();
        outs.SetLength(0);

        byte[] buffer = new byte[1024 * 512];
        long readLen = 0;
        long totlen = ins.Length;
        int len;


        DES des = new DESCryptoServiceProvider();
        CryptoStream encStream = new CryptoStream(outs, des.CreateDecryptor(desKey, desIv), CryptoStreamMode.Write);

        while (readLen < totlen)
        {
            len = ins.Read(buffer, 0, buffer.Length);
            encStream.Write(buffer, 0, len);
            readLen += len;
        }
        encStream.Close();
        outs.Close();
        ins.Close();


        return outs.ToArray();

    }
}
