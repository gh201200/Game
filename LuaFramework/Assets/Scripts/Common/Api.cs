using System;
using UnityEngine;
using System.Collections;
using System.Text;

[SLua.CustomLuaClass]
public class Api
{
    public static bool FirstRun
    {
        get { return !System.IO.File.Exists(Application.persistentDataPath + "/AssetsInfo.json") || System.IO.File.Exists(Application.persistentDataPath + "/data.zip"); }
    }

    public static string GetString(byte[] buffer)
    {
        return Encoding.UTF8.GetString(buffer);
    }

    public static byte[] GetBytes(string str)
    {
        return Encoding.UTF8.GetBytes(str);
    }

    public static void Quit()
    {
#if UNITY_EDITOR
        UnityEditor.EditorApplication.isPlaying = false;
#else
        Application.Quit();
#endif
    }

    public static string GetFormatFileSize(long totalSize)
    {
        string str = "";
        if (totalSize < 1024)
            str = totalSize + "B";
        else if (totalSize >= 1024 && totalSize < 1024 * 1024)
            str = Math.Round(totalSize / 1024d, 1) + "KB";
        else
            str = Math.Round(totalSize / 1024d / 1024d, 1) + "M";
        return str;
    }
}
