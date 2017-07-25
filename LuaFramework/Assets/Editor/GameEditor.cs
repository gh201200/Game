using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using SLua;
using UnityEditor;
using Object = UnityEngine.Object;
using Debug = UnityEngine.Debug;
using ICSharpCode.SharpZipLib.Zip;
using System.Diagnostics;
using System.Timers;

public class GameEditor
{
    public static string buildSettingPath = "Assets/Editor/BuildSetting.asset";

    [MenuItem("Tool/Test", false, 1000)]
    static void Test()
    {
        Stopwatch sp = new Stopwatch();
        sp.Start();
        //Debug.Log("begin compress file");
        //string path = @"C:\Users\Administrator\Desktop\PDF\Android开发入门教程.pdf";
        //ZipUtil.PackFile(path, @"C:\Users\Administrator\Desktop\test.zip", (cur, total) =>
        //{
        //    string content = (((double)cur / total) * 100).ToString("0.0") + "% " + (cur / 1024d / 1024d).ToString("0.0") + "M/" + (total / 1024d / 1024d).ToString("0.0") + "M";
        //    Debug.Log(content);
        //}, () =>
        //{
        //    Debug.Log("compress finish! 耗时:" + sp.Elapsed.TotalSeconds + "s");
        //    sp.Stop();
        //}, 9, "123456");

        //Debug.Log("begin compress file");
        //string path = @"D:\SocketPrograming\SocketPrograming\ScrollView";
        //ZipUtil.PackDirectory(path, @"C:\Users\Administrator\Desktop\test.zip", (cur, total) =>
        //{
        //    string content = (((double)cur / total) * 100).ToString("0.0") + "%    " + (cur / 1024d / 1024d).ToString("0.0") + "M/" + (total / 1024d / 1024d).ToString("0.0") + "M";
        //    Debug.Log(content);
        //}, () =>
        //{
        //    Debug.Log("compress finish! 耗时:" + sp.Elapsed.TotalSeconds + "s");
        //});

        //string pach = @"E:\美术策划资源\美术资源.zip";
        //ZipUtil.UnpackFileAsync(@"C:\Users\Administrator\Desktop\test", pach, (cur, total) =>
        //{
        //    string content = (((double)cur / total) * 100).ToString("0.0") + "%    " + (cur / 1024d / 1024d).ToString("0.0") + "M/" + (total / 1024d / 1024d).ToString("0.0") + "M";
        //    Debug.Log(content);
        //}, () => Debug.Log("unpack finish! 耗时:" + sp.Elapsed.TotalSeconds + "s"));

        string content = "";
        float progress = 0f;
        try
        {
            ZipUtil.UnpackFile(@"C:\Users\Administrator\Desktop\test", Config.StreamingAssetsPath + "/data.zip",
                (cur, total) =>
                {
                    progress = (float)cur / total;
                    content = (progress * 100).ToString("0.0") + "% " + (cur / 1024d / 1024d).ToString("0.0") + "M/" +
                              (total / 1024d / 1024d).ToString("0.0") + "M";
                    EditorUtility.DisplayProgressBar("progress", content, progress);
                },
                () =>
                {
                    Debug.Log("unpack finish! 耗时:" + sp.Elapsed.TotalSeconds + "s");
                });
        }
        catch (Exception e)
        {
            throw new Exception(e.Message);
        }
        finally
        {
            EditorUtility.ClearProgressBar();
            AssetDatabase.Refresh();
        }
    }

    [MenuItem("Tool/BuildSetting", false, 1)]
    static void BuildSetting()
    {
        Object obj = GetBuildSettingAsset();
        EditorUtility.FocusProjectWindow();
        Selection.activeObject = obj;
    }

    [MenuItem("Tool/AssetBundle/Build Single", false, 10)]
    static void BuildSingle()
    {
        AddResVersion();
#if PerFile
        //每个文件都是一个AssetBundle
#else
        //每个文件夹都是一个AssetBundle
#endif
    }

    [MenuItem("Tool/AssetBundle/Build All", false, 20)]
    static void BuildAll()
    {
        BuildSetting bs = GetBuildSettingAsset();
        HashSet<string> files = GetAllAssets();
        AddResVersion();

#if PerFile
        //每个文件是一个AssetBundle
        foreach (string str in files)
        {
            string fileName = Path.GetFileName(str);
            string bundleTag = str.Replace("Assets/", "").Replace(fileName, "") + Path.GetFileNameWithoutExtension(str) + ".bytes";
            AssetImporter ai = AssetImporter.GetAtPath(str);
            ai.assetBundleName = bundleTag;
            ai.assetBundleVariant = null;
        }
#else
        //每个文件夹下的文件是一个AssetBundle
        foreach (string str in files)
        {
            string fileName = Path.GetFileName(str);
            string bundleTag = str.Replace("Assets/", "").Replace("/" + fileName, "") + ".bytes";
            AssetImporter ai = AssetImporter.GetAtPath(str);
            ai.assetBundleName = bundleTag;
            ai.assetBundleVariant = null;
        }
#endif
        string buildPath = Application.dataPath.Replace("/Assets", "/") + bs.buildPath;
        DirectoryInfo di = new DirectoryInfo(buildPath);
        if (!di.Exists) di.Create();
        BuildPipeline.BuildAssetBundles(bs.buildPath, BuildAssetBundleOptions.ChunkBasedCompression | BuildAssetBundleOptions.DeterministicAssetBundle, bs.buildTarget);
        AssetDatabase.RemoveUnusedAssetBundleNames();
        AssetDatabase.Refresh();
    }

    [MenuItem("Tool/AssetBundle/Remove Unused AssetBundle Name", false, 30)]
    static void RemoveUnusedAssetBundleName()
    {
        AssetDatabase.RemoveUnusedAssetBundleNames();
        Debug.Log("clear success!");
    }

    [MenuItem("Tool/AssetBundle/Remove All AssetBundle Name", false, 40)]
    static void RemoveAllAssetBundleName()
    {
        foreach (string file in GetAllAssets())
        {
            AssetImporter ai = AssetImporter.GetAtPath(file);
            if (ai.assetBundleVariant != null) ai.assetBundleVariant = null;
            if (ai.assetBundleName != null) ai.assetBundleName = null;
        }
        RemoveUnusedAssetBundleName();
    }

    [MenuItem("Tool/AssetBundle/Clear ResVersion Record", false, 50)]
    static void ClearResVersionRecord()
    {
        EditorPrefs.DeleteKey("BuildVersion");
        GetBuildSettingAsset().resVersion = EditorPrefs.GetInt("BuildVersion");
        Debug.Log("clear success!");
    }

    [MenuItem("Tool/AssetBundle/Clear AssetBundles", false, 60)]
    static void ClearAssetBundles()
    {
        BuildSetting bs = GetBuildSettingAsset();
        string path = Application.dataPath.Replace("Assets", "") + bs.buildPath;
        path = path.Replace('/', '\\');
        foreach (
            var file in
                Directory.GetDirectories(path, "*",
                    SearchOption.TopDirectoryOnly))
        {
            if (file.Contains("LuaScripts")) continue;
            Directory.Delete(file, true);
        }
        path = Path.GetDirectoryName(path);
        int index = path.LastIndexOf('\\');
        string name = path.Substring(index + 1);
        string f1 = path + "\\" + name;
        string f2 = path + "\\" + name + ".manifest";
        if (File.Exists(f1)) File.Delete(f1);
        if (File.Exists(f2)) File.Delete(f2);
        AssetDatabase.Refresh();

    }

    [MenuItem("Tool/Compile LuaScripts", false, 100)]
    static void CompileLuaScripts()
    {
        LuajitGen.exportLuajit(Config.LuaPath.Replace(Application.dataPath.Replace("Assets", ""), ""), "*.lua", GetBuildSettingAsset().buildPath + "LuaScripts/", JITBUILDTYPE.X86);
    }

    [MenuItem("Tool/Pack Assets", false, 200)]
    static void PackAssets()
    {
        Debug.Log("begin pack");
        Stopwatch sp = new Stopwatch();
        sp.Start();
        BuildSetting bs = GetBuildSettingAsset();
        string path = Application.dataPath.Replace("Assets", "") + bs.buildPath;
        path = path.Replace('/', '\\');

        string content = "";
        float progress = 0f;
        try
        {
            ZipUtil.PackDirectory(path, Config.StreamingAssetsPath + "/data.zip", (cur, total) =>
            {
                progress = (float)cur / total;
                content = (progress * 100).ToString("0.0") + "% " + (cur / 1024d / 1024d).ToString("0.0") + "M/" +
                          (total / 1024d / 1024d).ToString("0.0") + "M";
                EditorUtility.DisplayProgressBar("progress", content, progress);
            },
                () =>
                {
                    Debug.Log("pack finish! 耗时:" + sp.Elapsed.TotalSeconds + "s");
                });
        }
        catch (Exception e)
        {
            throw new Exception(e.Message);
        }
        finally
        {
            EditorUtility.ClearProgressBar();
            AssetDatabase.Refresh();
        }
    }

    static HashSet<string> GetAllAssets()
    {
        BuildSetting bs = GetBuildSettingAsset();
        string[] files = Directory.GetFiles(Application.dataPath.Replace("Assets", "") + bs.resPath, "*", SearchOption.AllDirectories);
        HashSet<string> all = new HashSet<string>();
        foreach (string str in files)
        {
            if (str.EndsWith(".cs") || str.EndsWith(".meta")) continue;
            string path = str.Replace('\\', '/');
            path = "Assets" + path.Replace(Application.dataPath, "");
            if (!all.Contains(path)) all.Add(path);
        }
        return all;
    }

    static void AddResVersion()
    {
        int curVersion = EditorPrefs.GetInt("BuildVersion");
        EditorPrefs.SetInt("BuildVersion", ++curVersion);
        BuildSetting bs = GetBuildSettingAsset();
        bs.resVersion = curVersion;
        AssetDatabase.Refresh();
    }

    static BuildSetting GetBuildSettingAsset()
    {
        string path = Application.dataPath + "/" + buildSettingPath.Replace("Assets/", "");
        FileInfo info = new FileInfo(path);
        Object obj = null;
        if (!info.Exists)
        {
            obj = ScriptableObject.CreateInstance<BuildSetting>();
            AssetDatabase.CreateAsset(obj, buildSettingPath);
            AssetDatabase.Refresh();
        }
        else
        {
            obj = AssetDatabase.LoadAssetAtPath<BuildSetting>(buildSettingPath);
        }
        return obj as BuildSetting;
    }

    public static void AddSymbols(string str)
    {
        List<string> defines = PlayerSettings.GetScriptingDefineSymbolsForGroup(EditorUserBuildSettings.selectedBuildTargetGroup).Split(';').ToList();
        if (defines.Contains(str)) return;
        defines.Add(str);
        string temp = String.Join(";", defines.ToArray());
        PlayerSettings.SetScriptingDefineSymbolsForGroup(EditorUserBuildSettings.selectedBuildTargetGroup, temp);
    }

    public static void RemoveSymbols(string str)
    {
        List<string> defines = PlayerSettings.GetScriptingDefineSymbolsForGroup(EditorUserBuildSettings.selectedBuildTargetGroup).Split(';').ToList();
        if (!defines.Contains(str)) return;
        defines.Remove(str);
        string temp = String.Join(";", defines.ToArray());
        PlayerSettings.SetScriptingDefineSymbolsForGroup(EditorUserBuildSettings.selectedBuildTargetGroup, temp);
    }

    public static bool ExistsSymbols(string str)
    {
        List<string> defines = PlayerSettings.GetScriptingDefineSymbolsForGroup(EditorUserBuildSettings.selectedBuildTargetGroup).Split(';').ToList();
        return defines.Contains(str);
    }
}
