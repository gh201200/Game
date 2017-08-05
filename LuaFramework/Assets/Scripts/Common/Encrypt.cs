using UnityEngine;
using System.Collections;
using System.Security.Cryptography;
using System.IO;

public class Encrypt
{

    //DES需要秘钥desKey和desIv向量一起使用加密，它们的要求都是8个数组的字节数组， 如desKey=12345678转成字节数组  
    private static byte[] desIv = new byte[] { 0xF, 0x56, 0x52, 0xCD, 0xFF, 0x3F, 0x5D, 0x4 };

    /// <summary>  
    /// 传入需要加密的文件地址，生成新的加密后的文件  
    /// </summary>  
    /// <param name="inFilePath">需要加密的文件路径</param>  
    /// <param name="outFilePath">生成的加密过的文件</param>  
    /// <param name="key">加密秘钥</param>  
    public static void EncryptFile(string inFilePath, string outFilePath, int key)
    {

        string desKeyStr = key.ToString();
        byte[] desKey = System.Text.Encoding.UTF8.GetBytes(desKeyStr.Substring(0, 8));
        FileStream ins = new FileStream(inFilePath, FileMode.Open, FileAccess.Read);
        FileStream outs = new FileStream(outFilePath, FileMode.OpenOrCreate, FileAccess.Write);
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



    }

    /// <summary>  
    /// 传入需要解密的文件地址，生成解密后的文件  
    /// </summary>  
    /// <param name="inFilePath">需解密的文件</param>  
    /// <param name="outFilePath">生成新的解密后的文件</param>  
    /// <param name="key">秘钥和加密时的一致</param>  
    public static void DecryptFile(string inFilePath, string outFilePath, int key)
    {


        string desKeyStr = key.ToString();
        byte[] desKey = System.Text.Encoding.UTF8.GetBytes(desKeyStr.Substring(0, 8));
        FileStream ins = new FileStream(inFilePath, FileMode.Open, FileAccess.Read);
        FileStream outs = new FileStream(outFilePath, FileMode.OpenOrCreate, FileAccess.Write);
        outs.SetLength(0);

        byte[] buffer = new byte[1024 * 512];
        long readLen = 0;
        long totlLen = ins.Length;
        int len;

        DES des = new DESCryptoServiceProvider();
        CryptoStream dencStream = new CryptoStream(outs, des.CreateDecryptor(desKey, desIv), CryptoStreamMode.Write);

        while (readLen < totlLen)
        {
            len = ins.Read(buffer, 0, buffer.Length);
            dencStream.Write(buffer, 0, len);
            readLen += len;
        }

        dencStream.Close();
        outs.Close();
        ins.Close();


    }

    /// <summary>  
    /// 读取文件解密后的字节数组  
    /// </summary>  
    /// <param name="inFilePath">需要读取的加密过的文件</param>  
    /// <param name="key"></param>  
    /// <returns>返回文件解密过的字节数组对象</returns>  
    public static byte[] GetDecryptBytes(string inFilePath, int key)
    {

        string desKeyStr = key.ToString();
        byte[] desKey = System.Text.Encoding.UTF8.GetBytes(desKeyStr.Substring(0, 8));
        FileStream ins = new FileStream(inFilePath, FileMode.Open, FileAccess.Read);

        MemoryStream ms = new MemoryStream();//内存流，作为流和字节传送的临时媒介  
        ms.SetLength(0);

        byte[] buffer = new byte[1024 * 512];
        long readLen = 0;
        long totlLen = ins.Length;
        int len;

        DES des = new DESCryptoServiceProvider();
        CryptoStream dencStream = new CryptoStream(ms, des.CreateDecryptor(desKey, desIv), CryptoStreamMode.Write);


        while (readLen < totlLen)
        {
            len = ins.Read(buffer, 0, buffer.Length);
            dencStream.Write(buffer, 0, len);
            readLen += len;
        }
        byte[] ret = ms.ToArray();

        dencStream.Close();
        ms.Close();
        ins.Close();


        return ret;

    }

    /// <summary>  
    /// 对字节数组进行加密  
    /// </summary>  
    /// <param name="srcBs">需要加密的字节数组对象</param>  
    /// <param name="key"></param>  
    /// <returns>返回加密过的字节数组</returns>  
    public static byte[] EncryptBytes(byte[] srcBs, int key)
    {


        string desKeyStr = key.ToString();
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
    public static byte[] DecryptBytes(byte[] srcBs, int key)
    {


        string desKeyStr = key.ToString();
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