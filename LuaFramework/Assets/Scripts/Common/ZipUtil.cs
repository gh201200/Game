using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using ICSharpCode.SharpZipLib.Zip;

public class ZipUtil
{
    /// <summary>
    /// 压缩单个文件
    /// </summary>
    /// <param name="file">需要压缩的文件路径</param>
    /// <param name="zipFile">创建压缩包的路径</param>
    /// <param name="packLevel">压缩级别(1-9)</param>
    /// <param name="passwd">密码</param>
    public static void PackFileAsync(string file, string zipFile, Action<long, long> progress = null, Action complete = null, int packLevel = 6, string passwd = null)
    {
        Action temp = () =>
        {
            PackFile(file, zipFile, progress, complete, packLevel, passwd);
        };
        temp.BeginInvoke(null, null);
    }
    /// <summary>
    /// 压缩单个文件
    /// </summary>
    /// <param name="file">需要压缩的文件路径</param>
    /// <param name="zipFile">创建压缩包的路径</param>
    /// <param name="packLevel">压缩级别(1-9)</param>
    /// <param name="passwd">密码</param>
    public static void PackFile(string file, string zipFile, Action<long, long> progress = null, Action complete = null, int packLevel = 6, string passwd = null)
    {
        if (!File.Exists(file))
        {
            Debug.LogError("file to pack is not found!");
            return;
        }
        ZipOutputStream os = new ZipOutputStream(File.Create(zipFile));
        ZipEntry entry = new ZipEntry(Path.GetFileName(file));
        FileStream fs = new FileStream(file, FileMode.Open);
        try
        {
            int curLength = 0;
            entry.IsUnicodeText = true;             //防止中文乱码
            entry.DateTime = DateTime.Now;
            entry.Size = fs.Length;
            os.PutNextEntry(entry);
            os.SetLevel(packLevel);
            os.Password = passwd;
            Debug.Log(packLevel + " " + passwd);
            int length = 0;
            byte[] buffer = new byte[1024 * 1024];   //每次读取一兆的字节

            while (true)
            {
                length = fs.Read(buffer, 0, buffer.Length);
                if (length <= 0) break;
                os.Write(buffer, 0, length);
                curLength += length;
                if (progress != null) progress(curLength, fs.Length);
            }
            if (complete != null) complete();
        }
        catch (Exception e)
        {
            throw new Exception(e.Message);
        }
        finally
        {
            fs.Close();
            os.Finish();
            os.Close();
        }
    }

    /// <summary>
    /// 压缩文件夹
    /// </summary>
    /// <param name="dir"></param>
    /// <param name="zipFile"></param>
    /// <param name="progress"></param>
    /// <param name="complete"></param>
    /// <param name="packLevel"></param>
    /// <param name="passwd"></param>
    public static void PackDirectoryAsync(string dir, string zipFile, Action<long, long> progress = null, Action complete = null, int packLevel = 6, string passwd = null)
    {
        Action temp = () =>
        {
            PackDirectory(dir, zipFile, progress, complete, packLevel, passwd);
        };
        temp.BeginInvoke(null, null);
    }

    /// <summary>
    /// 压缩文件夹
    /// </summary>
    /// <param name="dir"></param>
    /// <param name="zipFile"></param>
    /// <param name="progress"></param>
    /// <param name="complete"></param>
    /// <param name="packLevel"></param>
    /// <param name="passwd"></param>
    public static void PackDirectory(string dir, string zipFile, Action<long, long> progress = null, Action complete = null, int packLevel = 6, string passwd = null)
    {
        dir = dir.Replace('/', '\\');
        if (!dir.EndsWith("\\")) dir += "\\";

        DirectoryInfo dirInfo = new DirectoryInfo(dir);
        if (!dirInfo.Exists)
        {
            Debug.LogError("pack failed!" + "\n" + dir + " is not found!");
            return;
        }

        string zipDir = Path.GetDirectoryName(zipFile);
        DirectoryInfo zipDirInfo = new DirectoryInfo(zipDir);
        if (!zipDirInfo.Exists) zipDirInfo.Create();

        long totalSize = dirInfo.GetFiles("*", SearchOption.AllDirectories).Sum(info => info.Length);
        long readSize = 0;

        string[] files = Directory.GetFiles(dir, "*", SearchOption.AllDirectories);

        if (File.Exists(zipFile)) File.Delete(zipFile);

        ZipOutputStream os = new ZipOutputStream(File.Create(zipFile));

        try
        {
            foreach (var file in files)
            {
                if (file.EndsWith(".meta")) continue;
                FileStream fs = File.Open(file, FileMode.Open);
                ZipEntry entry = new ZipEntry(file.Replace(dir, ""));
                entry.IsUnicodeText = true;
                entry.DateTime = DateTime.Now;
                entry.Size = fs.Length;
                os.PutNextEntry(entry);
                os.SetLevel(packLevel);
                os.Password = passwd;
                byte[] buffer = new byte[1024 * 1024];
                while (true)
                {
                    var length = fs.Read(buffer, 0, buffer.Length);
                    if (length <= 0) break;
                    readSize += length;
                    os.Write(buffer, 0, length);
                    if (progress != null) progress(readSize, totalSize);
                }
                fs.Close();
                fs.Dispose();
            }
            if (complete != null) complete();
        }
        catch (Exception e)
        {
            throw new Exception(e.Message);
        }
        finally
        {
            os.Finish();
            os.Close();
        }
    }

    /// <summary>
    /// 解压缩包
    /// </summary>
    /// <param name="dir"></param>
    /// <param name="zipFile"></param>
    /// <param name="progress"></param>
    /// <param name="complete"></param>
    /// <param name="passwd"></param>
    public static void UnpackFileAsync(string dir, string zipFile, Action<long, long> progress = null, Action complete = null, string passwd = null)
    {
        Action temp = () =>
        {
            UnpackFile(dir, zipFile, progress, complete, passwd);
        };
        temp.BeginInvoke(null, null);
    }

    /// <summary>
    /// 解压缩包
    /// </summary>
    /// <param name="dir"></param>
    /// <param name="zipFile"></param>
    /// <param name="progress"></param>
    /// <param name="complete"></param>
    /// <param name="passwd"></param>
    public static void UnpackFile(string dir, string zipFile, Action<long, long> progress = null, Action complete = null, string passwd = null)
    {
        Debug.Log("begin unpack file");
        dir = dir.Replace('/', '\\');
        if (!dir.EndsWith("\\")) dir += "\\";
        FileInfo info = new FileInfo(zipFile);
        if (!info.Exists)
        {
            Debug.LogError("unpack failed!" + "\n" + zipFile + " is not found!");
            return;
        }
        ZipInputStream reader = new ZipInputStream(File.Open(zipFile, FileMode.Open));
        ZipEntry entry = null;
        long totalSize = info.Length;
        long readSize = 0;
        try
        {
            while ((entry = reader.GetNextEntry()) != null)
            {
                entry.IsUnicodeText = true;

                if (entry.IsDirectory) continue;

                string dir_part = Path.GetDirectoryName(entry.Name);
                dir_part = dir_part.Replace('/', '\\');
                if (!dir_part.EndsWith("\\")) dir_part += "\\";

                string fullDir = dir + dir_part;

                if (!Directory.Exists(fullDir)) Directory.CreateDirectory(fullDir);

                string filePath = fullDir + Path.GetFileName(entry.Name);

                if (File.Exists(filePath)) File.Delete(filePath);

                FileStream fs = new FileStream(filePath, FileMode.CreateNew);

                byte[] buffer = new byte[1024 * 1024];
                int length = 0;
                while (true)
                {
                    length = reader.Read(buffer, 0, buffer.Length);
                    if (length <= 0) break;
                    fs.Write(buffer, 0, length);
                    if (progress != null) progress(readSize, totalSize);
                }
                readSize += entry.CompressedSize;
                fs.Close();
                fs.Dispose();
            }
            if (complete != null) complete();
        }
        catch (Exception e)
        {
            throw new Exception(e.Message);
        }
        finally
        {
            reader.Close();
            reader.Dispose();
        }
    }
}
