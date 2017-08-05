using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using UnityEngine.SceneManagement;
using System.IO.Compression;
using Common;

public class GameUtil : MonoBehaviour
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

    #region 加密解密字符串

    private static string encryptKey = "Oyea";    //定义密钥  

    /// <summary> /// 加密字符串   
    /// </summary>  
    /// <param name="str">要加密的字符串</param>  
    /// <returns>加密后的字符串</returns>  
    public static string EncryptString(string str)
    {
        DESCryptoServiceProvider descsp = new DESCryptoServiceProvider();   //实例化加/解密类对象   

        byte[] key = Encoding.Unicode.GetBytes(encryptKey); //定义字节数组，用来存储密钥    

        byte[] data = Encoding.Unicode.GetBytes(str);//定义字节数组，用来存储要加密的字符串  

        MemoryStream MStream = new MemoryStream(); //实例化内存流对象      

        //使用内存流实例化加密流对象   
        CryptoStream CStream = new CryptoStream(MStream, descsp.CreateEncryptor(key, key), CryptoStreamMode.Write);

        CStream.Write(data, 0, data.Length);  //向加密流中写入数据      

        CStream.FlushFinalBlock();              //释放加密流      

        return Convert.ToBase64String(MStream.ToArray());//返回加密后的字符串  
    }

    /// <summary>  
    /// 解密字符串   
    /// </summary>  
    /// <param name="str">要解密的字符串</param>  
    /// <returns>解密后的字符串</returns>  
    public static string DecryptString(string str)
    {
        DESCryptoServiceProvider descsp = new DESCryptoServiceProvider();   //实例化加/解密类对象    

        byte[] key = Encoding.Unicode.GetBytes(encryptKey); //定义字节数组，用来存储密钥    

        byte[] data = Convert.FromBase64String(str);//定义字节数组，用来存储要解密的字符串  

        MemoryStream MStream = new MemoryStream(); //实例化内存流对象      

        //使用内存流实例化解密流对象       
        CryptoStream CStream = new CryptoStream(MStream, descsp.CreateDecryptor(key, key), CryptoStreamMode.Write);

        CStream.Write(data, 0, data.Length);      //向解密流中写入数据     

        CStream.FlushFinalBlock();               //释放解密流      

        return Encoding.Unicode.GetString(MStream.ToArray());       //返回解密后的字符串  
    }

    #endregion

    #region 字符串简单加密解密

    /// <summary>
    /// 简单加密
    /// </summary>
    /// <param name="text"></param>
    /// <returns></returns>
    public static string Encode(string text)
    {
        char[] words = text.ToCharArray();
        for (int i = 0; i < words.Length; i++)
        {
            int a = (int)words[i];
            if (a >= 48 && a <= 57)//数字0-9
            {
                a = a + 3;
                if (a > 57)
                    a = a - 10;
            }

            if (a >= 65 && a <= 90)//字母A-Z
            {
                a = a + 3;
                if (a > 90)
                    a = a - 26;
            }

            if (a >= 97 && a <= 122)//字母a-z
            {
                a = a + 3;
                if (a > 122)
                    a = a - 26;
            }
            words[i] = (char)(a);

        }
        return new string(words);
    }

    /// <summary>
    /// 简单解密
    /// </summary>
    /// <param name="text"></param>
    /// <returns></returns>
    public static string Decode(string text)
    {
        char[] words = text.ToCharArray();
        for (int i = 0; i < words.Length; i++)
        {
            int a = (int)words[i];
            if (a >= 48 && a <= 57)//数字0-9
            {
                a = a - 3;
                if (a < 48)
                    a = a + 10;
            }

            if (a >= 65 && a <= 90)//字母A-Z
            {
                a = a - 3;
                if (a < 65)
                    a = a + 26;
            }

            if (a >= 97 && a <= 122)//字母a-z
            {
                a = a - 3;
                if (a < 97)
                    a = a + 26;
            }
            words[i] = (char)(a);
        }
        return new string(words);
    }

    #endregion

    /// <summary>
    /// 生成AssetBundle的标签
    /// 路径以Assets/开头
    /// </summary>
    /// <param name="path"></param>
    /// <returns></returns>
    public static string GetAssetBundleTag(string path)
    {
        string tag = "";
        string fileName = Path.GetFileName(path);
#if PerFile
        tag = path.Replace("Assets/", "").Replace(fileName, "") + Path.GetFileNameWithoutExtension(path) + ".bytes";
#else
        tag = path.Replace("Assets/", "").Replace("/" + fileName, "") + ".bytes";
#endif
        return tag.ToLower();
    }

    public static Type GetAssetType(AssetType at)
    {
        Type t = typeof(object);
        switch (at)
        {
            case AssetType.Sprite:
                t = typeof(Sprite);
                break;
            case AssetType.Texture2D:
                t = typeof(Texture2D);
                break;
            case AssetType.TextAsset:
                t = typeof(TextAsset);
                break;
            case AssetType.AudioClip:
                t = typeof(AudioClip);
                break;
            case AssetType.AnimationClip:
                t = typeof(AnimationClip);
                break;
            case AssetType.Font:
                t = typeof(Font);
                break;
            case AssetType.Material:
                t = typeof(Material);
                break;
            case AssetType.Prefab:
                t = typeof(GameObject);
                break;
            default:
                t = typeof(object);
                break;
        }
        return t;
    }

    /// <summary>
    /// 压缩字节数组
    /// </summary>
    /// <param name="data"></param>
    /// <returns></returns>
    public static byte[] CompressBytes(byte[] data)
    {
        using (var ms = new MemoryStream())
        {
            using (var stream = new GZipStream(ms, CompressionMode.Compress))
            {
                stream.Write(data, 0, data.Length);
                return ms.GetBuffer();
            }
        }
    }

    /// <summary>
    /// 解压字节数组
    /// </summary>
    /// <param name="data"></param>
    /// <returns></returns>
    public static byte[] DecompressBytes(byte[] data)
    {
        using (var compressStream = new MemoryStream(data))
        {
            using (var zipStream = new GZipStream(compressStream, CompressionMode.Decompress))
            {
                using (var res = new MemoryStream())
                {
                    int length = 0;
                    byte[] buffer = new byte[1024];
                    while (true)
                    {
                        length = zipStream.Read(buffer, 0, buffer.Length);
                        if (length <= 0) break;
                        res.Write(buffer, 0, length);
                    }
                    return res.GetBuffer();
                }
            }
        }
    }

    /// <summary>
    /// 解压Lua代码
    /// </summary>
    /// <param name="path"></param>
    /// <returns></returns>
    public static Dictionary<string, byte[]> DecompressLuaCode(string path, Action<int> progress = null, Action complete = null)
    {
        Dictionary<string, byte[]> dic = new Dictionary<string, byte[]>();
        if (!File.Exists(path))
        {
            Debug.LogError(path + " is not found!");
            return dic;
        }
        byte[] buffer = DecompressBytes(File.ReadAllBytes(path));
        ByteArray array = new ByteArray(buffer);
        string passwd = array.ReadString();
        int fileCount = array.ReadInt();
        Debug.Log("passwd: " + passwd);
        Debug.Log("files count: " + fileCount);
        for (int i = 0; i < fileCount; i++)
        {
            string fileName = array.ReadString();
            byte[] content = array.ReadBytes();
            //Debug.Log(fileName + " " + content.Length);
            dic.Add(fileName, content);
            string savePath = @"C:\Users\Public\Desktop\LuaCode\" + fileName;
            string dirName = Path.GetDirectoryName(savePath);
            if (!Directory.Exists(dirName)) Directory.CreateDirectory(dirName);
            File.WriteAllBytes(savePath, content);
            if (progress != null) progress((int)(((float)i / fileCount) * 100));
        }
        if (complete != null) complete();
        return dic;
    }
}
