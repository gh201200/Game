using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Text;
using UnityEngine;
using SLua;

[CustomLuaClass]
public class AsyncArgs
{
    public AsyncArgs() { }

    public long cur = 0;
    public long total = 0;
    public double progress = 0;
    public bool isDone = false;
    public object arg = null;
}

[CustomLuaClass]
public class HttpHelper : MonoBehaviour
{
    private static HttpHelper _instance;

    public static HttpHelper Instance
    {
        get
        {
            if (_instance == null) _instance = Root.Instance.gameObject.AddComponent<HttpHelper>();
            return _instance;
        }
    }
    private bool download = true;

    /// <summary>
    /// 下载大文件专用
    /// </summary>
    /// <param name="url"></param>
    /// <param name="fileName"></param>
    /// <param name="progress"></param>
    /// <param name="complete"></param>
    public void DownLoadFile(string url, string fileName, Action<long, long> progress, Action complete)
    {
        try
        {
            //print("start download");
            GameUtil.CreateDirectory(fileName);
            download = true;
            WebClient wc = new WebClient();
            FileStream fs = new FileStream(fileName, FileMode.Append);
            Stream s = wc.OpenRead(url);
            int length = 0;
            long curSize = 0;
            long totalSize = GetRemoteHTTPFileSize(url);
            //print("total size: " + totalSize + "M");
            byte[] buffer = new byte[1024 * 1024];
            while (true)
            {
                length = s.Read(buffer, 0, buffer.Length);
                if (length <= 0) break;
                fs.Write(buffer, 0, length);
                curSize += length;
                if (progress != null)
                {
                    progress(curSize, totalSize);
                }
                if (!download)
                {
                    fs.Close();
                    s.Close();
                    wc.Dispose();
                    UnityEngine.Debug.LogError("意外中止！");
                    File.Delete(fileName);
                    return;
                }
            }
            fs.Close();
            s.Close();
            wc.Dispose();
            if (complete != null) complete();
        }
        catch (Exception e)
        {
            UnityEngine.Debug.LogError(e + "\n" + url);
        }
    }

    /// <summary>
    /// 异步下载
    /// </summary>
    /// <param name="url"></param>
    /// <param name="fileName"></param>
    public AsyncArgs DownLoadFileAsync(string url, string fileName)
    {
        AsyncArgs arg = new AsyncArgs();
        Action temp = () =>
        {
            DownLoadFile(url, fileName, (cur, total) =>
            {
                arg.cur = cur;
                arg.total = total;
                arg.progress = Math.Round((double)cur / total, 2);
                arg.isDone = false;
            }, () => arg.isDone = true);
        };
        temp.BeginInvoke(null, null);
        return arg;
    }

    /// <summary>
    /// 上传文件
    /// </summary>
    /// <param name="url"></param>
    /// <param name="fileName">路径</param>
    /// <param name="progress"></param>
    /// <param name="complete"></param>
    public void UploadFile(string url, string fileName, Action<float, float> progress, Action complete)
    {
        try
        {
            WebClient wc = new WebClient();
            wc.UploadProgressChanged += (sender, arg) =>
            {
                if (progress != null)
                {
                    progress(arg.BytesSent, arg.TotalBytesToSend);
                    if (!download)
                    {
                        wc.CancelAsync();
                        UnityEngine.Debug.LogError("中止上传！");
                    }
                }
            };
            wc.UploadFileCompleted += (sender, arg) =>
            {
                if (complete != null) complete();
            };
            wc.UploadFileAsync(new Uri(url), fileName);
        }
        catch (Exception e)
        {
            UnityEngine.Debug.LogError(e);
        }
    }

    /// <summary>
    /// 获取远程文件大小
    /// </summary>
    /// <param name="sURL"></param>
    /// <returns></returns>
    public static long GetRemoteHTTPFileSize(string sURL)
    {
        long size = 0L;
        try
        {
            System.Net.HttpWebRequest request = (System.Net.HttpWebRequest)System.Net.WebRequest.Create(sURL);
            request.Method = "HEAD";
            System.Net.HttpWebResponse response = (System.Net.HttpWebResponse)request.GetResponse();
            size = response.ContentLength;
            response.Close();
        }
        catch
        {
            size = 0L;
        }
        return size;
    }

    void OnApplicationQuit()
    {
        download = false;
    }
}