using System;
using UnityEngine;
using System.Collections;
using System.IO;
using System.Net;
using System.Diagnostics;

public class Test : MonoBehaviour
{

    private bool download = true;
    private UnityEngine.UI.Text t;
    private string str = "";

    IEnumerator Start()
    {
        //string url = @"http://localhost/TablePlus.lua";
        //using (WWW www = new WWW(url))
        //{
        //    yield return www;
        //    if (www.error != null)
        //    {
        //        throw new Exception(www.error);
        //    }
        //    print(www.text);
        //}
        yield return null;

        //WebClient wc = new WebClient();
        //Uri uri = new Uri(@"http://localhost/sp.mp4");
        //byte[] buffer = wc.DownloadData("http://localhost/C#高级编程第7版.pdf");
        //File.WriteAllBytes(Application.dataPath + "/TablePlus.lua", buffer);
        //UnityEditor.AssetDatabase.Refresh();

        //wc.Credentials = CredentialCache.DefaultCredentials;
        //FileStream fs = new FileStream(@"C:\Users\Administrator\Desktop\XXXXXXXXXX.mp4", FileMode.Append);
        //wc.DownloadProgressChanged += (sender, arg) =>
        //{
        //    print(arg.ProgressPercentage + "%" + " --- " + arg.BytesReceived + "/" + arg.TotalBytesToReceive);
        //};
        //wc.DownloadDataCompleted += (sender, arg) =>
        //{
        //    fs.Write(arg.Result, 0, arg.Result.Length);
        //    fs.Close();
        //    print("download complete!");
        //};
        //wc.DownloadDataAsync(new Uri(@"http://localhost/C#高级编程第7版.pdf"));

        //wc.DownloadProgressChanged += (sender, arg) =>
        //{
        //    print(arg.ProgressPercentage + "%" + " --- " + arg.BytesReceived + "/" + arg.TotalBytesToReceive);
        //};
        //wc.DownloadFileCompleted += (sender, arg) =>
        //{
        //    print("download complete!");
        //};
        //wc.DownloadFileAsync(new Uri(@"http://localhost/C#高级编程第7版.pdf"), @"C:\Users\Administrator\Desktop\XXXXXXXXXX.pdf");

        //Stream s = wc.OpenRead(@"http://localhost/sp.mp4");
        //int length = 0;
        //byte[] buffer = new byte[1024 * 1024];
        //while (true)
        //{
        //    length = s.Read(buffer, 0, buffer.Length);
        //    if (length <= 0) break;
        //    fs.Write(buffer, 0, length);
        //}
        //fs.Close();
        //s.Close();
        //print("download complete");

        //float totalSize = 300;
        //float curSize = 0;

        //wc.OpenReadCompleted += (sender, arg) =>
        //{
        //    print("open read complete callback " + arg.Result.Length);
        //    if (arg.Result.Length > 0)
        //    {
        //        byte[] buffer = new byte[1024 * 1024];
        //        int length = 0;
        //        while (true)
        //        {
        //            length = arg.Result.Read(buffer, 0, buffer.Length);
        //            if (length <= 0) break;
        //            fs.Write(buffer, 0, length);
        //            curSize += length / 1024f / 1024f;
        //            print(curSize + "/" + totalSize);
        //        }
        //        wc.OpenReadAsync(uri);
        //    }
        //};
        //wc.OpenReadAsync(uri);

        t = this.GetComponent<UnityEngine.UI.Text>();

        download = true;
        DownLoadFile(@"http://localhost/cc.pdf", @"C:\Users\Administrator\Desktop\cc.pdf", (cur, total) =>
        {
            str = "progress: " + cur.ToString("0.0") + "M/" + total.ToString("0.0") + "M";
        },
            () => print("download complete!"));
    }

    /// <summary>
    /// 下载文件
    /// </summary>
    /// <param name="url"></param>
    /// <param name="fileName"></param>
    /// <param name="progress"></param>
    /// <param name="complete"></param>
    public void DownLoadFile(string url, string fileName, Action<float, float> progress, Action complete)
    {
        Action<string, string, Action<float, float>, Action> act = (_url, _fileName, _progress, _complete) =>
        {
            try
            {
                print("start download");
                WebClient wc = new WebClient();
                FileStream fs = new FileStream(_fileName, FileMode.Append);
                Stream s = wc.OpenRead(_url);
                int length = 0;
                float curSize = 0f;
                float totalSize = GetRemoteHTTPFileSize(_url) / 1024f / 1024f;
                print("total size: " + totalSize + "M");
                byte[] buffer = new byte[1024 * 1024];
                while (true)
                {
                    length = s.Read(buffer, 0, buffer.Length);
                    if (length <= 0) break;
                    fs.Write(buffer, 0, length);
                    curSize += length / 1024f / 1024f;
                    if (_progress != null)
                    {
                        _progress(curSize, totalSize);
                    }
                    if (!download)
                    {
                        fs.Close();
                        s.Close();
                        wc.Dispose();
                        UnityEngine.Debug.LogError("意外中止！");
                        return;
                    }
                }
                fs.Close();
                s.Close();
                wc.Dispose();
                if (_complete != null) _complete();
            }
            catch (Exception e)
            {
                UnityEngine.Debug.LogError(e);
            }
        };
        act.BeginInvoke(url, fileName, progress, complete, null, null);
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

    void Update()
    {
        if (!t) return;
        t.text = str;
    }

    void OnApplicationQuit()
    {
        download = false;
    }
}
