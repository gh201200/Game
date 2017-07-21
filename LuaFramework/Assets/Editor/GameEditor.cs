using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using UnityEditor;
using Object = UnityEngine.Object;

public class GameEditor
{
    public static string buildSettingPath = "Assets/Editor/BuildSetting.asset";

    [MenuItem("Tool/Test", false, 1000)]
    static void Test()
    {
        GetAllAssets();
    }

    [MenuItem("Tool/BuildSetting", false, 0)]
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
        //每个文件都是一个AssetBundle
#else
        //每个文件夹都是一个AssetBundle
        foreach (string str in files)
        {
            string fileName = Path.GetFileName(str);
            string bundleTag = str.Replace(GetBuildSettingAsset().resPath, "").Replace(fileName, "") + Path.GetFileNameWithoutExtension(str) + ".bytes";
            AssetImporter ai = AssetImporter.GetAtPath(str);
            ai.assetBundleName = bundleTag;
            ai.assetBundleVariant = null;
        }
        string buildPath = Application.dataPath.Replace("/Assets", "/") + bs.buildPath;
        DirectoryInfo di = new DirectoryInfo(buildPath);
        if (!di.Exists) di.Create();
        BuildPipeline.BuildAssetBundles(bs.buildPath, BuildAssetBundleOptions.ChunkBasedCompression, bs.buildTarget);
#endif
    }

    [MenuItem("Tool/AssetBundle/Remove Unused AssetBundle Name", false, 30)]
    static void RemoveUnusedAssetBundleName()
    {
        AssetDatabase.RemoveUnusedAssetBundleNames();
        Debug.Log("clear success!");
    }

    [MenuItem("Tool/AssetBundle/Remove All AssetBundle Name", false, 30)]
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

    [MenuItem("Tool/AssetBundle/Clear ResVersion Record", false, 30)]
    static void ClearResVersionRecord()
    {
        EditorPrefs.DeleteKey("BuildVersion");
        GetBuildSettingAsset().resVersion = EditorPrefs.GetInt("BuildVersion");
        Debug.Log("clear success!");
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
