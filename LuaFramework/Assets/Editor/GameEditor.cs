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
using System.Text;
using System.Timers;
using System.Xml;
using MiniJSON;

public class GameEditor
{
    public static string buildSettingPath = "Assets/Editor/BuildSetting.asset";

    [MenuItem("Tool/Test", false, 1000)]
    static void Test()
    {
        ////测试解压
        //Stopwatch sp = new Stopwatch();
        //sp.Start();
        //string content = "";
        //float progress = 0f;
        //try
        //{
        //    ZipUtil.UnpackFile(@"C:\Users\Administrator\Desktop\Test", Config.StreamingAssetsPath + "/data.zip",
        //        (cur, total) =>
        //        {
        //            progress = (float)cur / total;
        //            content = (progress * 100).ToString("0.0") + "% " + (cur / 1024d / 1024d).ToString("0.0") + "M/" +
        //                      (total / 1024d / 1024d).ToString("0.0") + "M";
        //            EditorUtility.DisplayProgressBar("unpack zip", content, progress);
        //        },
        //        () =>
        //        {
        //            Debug.Log("unpack finish! 耗时:" + sp.Elapsed.TotalSeconds + "s");
        //        });
        //}
        //catch (Exception e)
        //{
        //    throw new Exception(e.Message);
        //}
        //finally
        //{
        //    EditorUtility.ClearProgressBar();
        //    AssetDatabase.Refresh();
        //}

        //GenerateAssetInfoXml();
        //GenerateAssetInfoJson();

        //AssetDesc desc = new AssetDesc("Prefabs/Tip.prefab", AssetType.Prefab);
        //Debug.Log("AssetName");
        //Debug.Log(desc.AssetName);
        //Debug.Log("AssetType");
        //Debug.Log(desc.AssetType);
        //Debug.Log("AssetBundleTag");
        //Debug.Log(desc.AssetBundleTag);
        //Debug.Log("RelativePath");
        //Debug.Log(desc.RelativePath);
        //Debug.Log("EditorPath");
        //Debug.Log(desc.EditorPath);
        //Debug.Log("FullPath");
        //Debug.Log(desc.FullPath);

        //HttpHelper.Instance.DownLoadFile("http://localhost/test.pdf", Application.dataPath + "/test.pdf", (cur, total) =>
        //{
        //    EditorUtility.DisplayProgressBar("download file", "http://localhost/test.pdf", cur / total);
        //}, () =>
        //{
        //    EditorUtility.ClearProgressBar();
        //    AssetDatabase.Refresh();
        //});

        //try
        //{
        //    ZipUtil.PackDirectory(Application.dataPath + "/Build/LuaScripts", Application.dataPath + "/LuaCode.zip",
        //        (cur, total) =>
        //        {
        //            EditorUtility.DisplayProgressBar("progress",
        //                "pack direcory..." + Mathf.Ceil((float)cur * 100 / total) + "%", (float)cur / total);
        //        });
        //}
        //catch
        //{
        //}
        //finally
        //{
        //    EditorUtility.ClearProgressBar();
        //    AssetDatabase.Refresh();
        //}

        AssetDesc desc = new AssetDesc("Prefabs/Panel/LoginPanel.prefab", AssetType.Prefab);
    }

    [MenuItem("Tool/BuildSetting", false, 1)]
    static void BuildSetting()
    {
        Object obj = GetBuildSettingAsset();
        EditorUtility.FocusProjectWindow();
        Selection.activeObject = obj;
    }

    //[MenuItem("Tool/AssetBundle/Build Single", false, 10)]
    static void BuildSingle()
    {
        AddResVersion();
        BuildSetting bs = GetBuildSettingAsset();
        RemoveAllAssetBundleName();
        UnityEngine.Object[] objs = Selection.objects;
        HashSet<string> buildList = new HashSet<string>();
        foreach (var obj in objs)
        {
            string path = AssetDatabase.GetAssetPath(obj);
            string[] dependencies = AssetDatabase.GetDependencies(path);
            foreach (string file in dependencies)
            {
                if (!file.StartsWith(bs.resPath))
                {
                    EditorUtility.DisplayDialog("error", "please make sure all dependencies assets in " + bs.resPath, "ok");
                    return;
                }
                string tag = GetAssetBundleTag(file);
                AssetImporter ai = AssetImporter.GetAtPath(file);
                ai.assetBundleName = tag;
                ai.assetBundleVariant = null;
                if (!buildList.Contains(tag)) buildList.Add(tag);
            }
        }
        Debug.Log("build list:");
        foreach (var file in buildList) Debug.Log(file);
        Build();
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
            string bundleTag = GetAssetBundleTag(str);
            AssetImporter ai = AssetImporter.GetAtPath(str);
            ai.assetBundleName = bundleTag;
            ai.assetBundleVariant = null;
        }
#else
        //每个文件夹下的文件是一个AssetBundle
        foreach (string str in files)
        {
            string bundleTag = GetAssetBundleTag(str);
            AssetImporter ai = AssetImporter.GetAtPath(str);
            ai.assetBundleName = bundleTag;
            ai.assetBundleVariant = null;
        }
#endif
        Build();
    }

    [MenuItem("Tool/AssetBundle/Remove Unused AssetBundle Name", false, 30)]
    static void RemoveUnusedAssetBundleName()
    {
        AssetDatabase.RemoveUnusedAssetBundleNames();
        //Debug.Log("clear success!");
    }

    [MenuItem("Tool/AssetBundle/Remove All AssetBundle Name", false, 40)]
    static void RemoveAllAssetBundleName()
    {
        foreach (string file in GetAllAssets())
        {
            AssetImporter ai = AssetImporter.GetAtPath(file);
            if (!string.IsNullOrEmpty(ai.assetBundleVariant)) ai.assetBundleVariant = null;
            if (!string.IsNullOrEmpty(ai.assetBundleName)) ai.assetBundleName = null;
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

    [MenuItem("Tool/Encrypt Lua Code", false, 100)]
    static void EncryptLuaCode()
    {
        try
        {
            string[] files = Directory.GetFiles(Application.dataPath + "/LuaScripts", "*.lua", SearchOption.AllDirectories);

            for (int i = 0; i < files.Length; i++)
            {
                string name = files[i];
                name = name.Replace('\\', '/');
                name = name.Replace(Application.dataPath + "/", "");
                string outName = Application.dataPath + "/Build/" + name;
                GameUtil.CreateDirectory(outName);
                EncryptUtil.EncryptFile(files[i], outName, "19930822");
                //byte[] compressedBytes = GameUtil.CompressBytes(File.ReadAllBytes(files[i]));
                //byte[] encryptBytes = EncryptUtil.EncryptBytes(compressedBytes, "19930822");
                //File.WriteAllBytes(outName, encryptBytes);
                EditorUtility.DisplayProgressBar("encrypt lua code...", name, (float)i / files.Length);
            }
            EditorUtility.ClearProgressBar();
            AssetDatabase.Refresh();
        }
        catch (Exception ex)
        {
            EditorUtility.ClearProgressBar();
            AssetDatabase.Refresh();
            throw new Exception(ex.Message + "\n" + ex.StackTrace);
        }
    }

    [MenuItem("Tool/Decrypt Lua Code", false, 101)]
    static void DecryptLuaCode()
    {
        try
        {
            string[] files = Directory.GetFiles(Application.dataPath + "/Build/LuaScripts", "*.lua", SearchOption.AllDirectories);

            for (int i = 0; i < files.Length; i++)
            {
                string name = files[i];
                name = name.Replace('\\', '/');
                name = name.Replace(Application.dataPath + "/Build/", "");
                string outName = @"C:\Users\Administrator\Desktop\" + name;
                GameUtil.CreateDirectory(outName);
                //byte[] decryptBytes = EncryptUtil.DecryptFileToBytes(files[i], "19930822");
                //byte[] decompressedBytes = GameUtil.DecompressBytes(decryptBytes);
                //File.WriteAllBytes(outName, decompressedBytes);
                EncryptUtil.DecryptFile(files[i], outName, "19930822");
                //GameUtil.CreateDirectory(outName);
                //File.WriteAllBytes(outName, Encrypt.DecryptFileToBytes(files[i], "19930822"));
                EditorUtility.DisplayProgressBar("decrypt lua code...", name, (float)i / files.Length);
            }
            EditorUtility.ClearProgressBar();
            AssetDatabase.Refresh();
        }
        catch (Exception ex)
        {
            EditorUtility.ClearProgressBar();
            AssetDatabase.Refresh();
            throw new Exception(ex.Message + "\n" + ex.StackTrace);
        }
    }

    [MenuItem("Tool/Clear Encrypt Lua Code", false, 103)]
    static void ClearLuaBytecode()
    {
        BuildSetting bs = GetBuildSettingAsset();
        string path = Application.dataPath.Replace("Assets", "") + bs.buildPath;
        path = path.Replace('/', '\\');
        DirectoryInfo di = new DirectoryInfo(path + "LuaScripts");
        if (di.Exists) di.Delete(true);
        AssetDatabase.Refresh();
    }

    [MenuItem("Tool/Push Assets To Remote", false, 150)]
    static void PushAssetsToRemote()
    {
        try
        {
            string path = Application.dataPath;
            int index = path.LastIndexOf("/", StringComparison.Ordinal);
            path = path.Substring(0, index);
            string exePath = path + "/UploadTools/Client/TCPClient.exe";
            string configPath = path + "/UploadTools/Client/Config.json";
            Process p = Process.Start(exePath, configPath);
            p.WaitForExit();
            Debug.Log("上传成功!");
        }
        catch (Exception ex)
        {
            Debug.Log(ex.Message);
        }
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
                EditorUtility.DisplayProgressBar("pack assets to zip", content, progress);
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

    [MenuItem("Assets/Reimport UI Assemblies", false, 100)]
    public static void ReimportUI()
    {
#if UNITY_4_6
        var path = EditorApplication.applicationContentsPath + "/UnityExtensions/Unity/GUISystem/{0}/{1}";
       var version = Regex.Match(Application.unityVersion, @"^[0-9]+\.[0-9]+\.[0-9]+").Value;
#else
        var path = EditorApplication.applicationContentsPath + "/UnityExtensions/Unity/GUISystem/{1}";
        var version = string.Empty;
#endif
        string engineDll = string.Format(path, version, "UnityEngine.UI.dll");
        string editorDll = string.Format(path, version, "Editor/UnityEditor.UI.dll");
        ReimportDll(engineDll);
        ReimportDll(editorDll);
    }

    [MenuItem("Tool/Compress Lua Code", false, 1001)]
    public static void CompressLuaCode()
    {
        string[] files = Directory.GetFiles(Application.dataPath + "/LuaScripts", "*.lua", SearchOption.AllDirectories);

        for (int i = 0; i < files.Length; i++)
        {
            string name = files[i];
            name = name.Replace('\\', '/');
            name = name.Replace(Application.dataPath + "/", "");
            string outName = Application.dataPath + "/Build/" + name;
            GameUtil.CreateDirectory(outName);
            byte[] cbytes = GameUtil.CompressBytes(File.ReadAllBytes(files[i]));
            File.WriteAllBytes(outName, cbytes);
            EditorUtility.DisplayProgressBar("encrypt lua code...", name, (float)i / files.Length);
        }
        EditorUtility.ClearProgressBar();
        AssetDatabase.Refresh();
    }

    [MenuItem("Tool/Decompress Lua Code", false, 1002)]
    public static void DecompressLuaCode()
    {
        string[] files = Directory.GetFiles(Application.dataPath + "/Build/LuaScripts", "*.lua", SearchOption.AllDirectories);

        for (int i = 0; i < files.Length; i++)
        {
            string name = files[i];
            name = name.Replace('\\', '/');
            name = name.Replace(Application.dataPath + "/Build/", "");
            string outName = @"C:\Users\Administrator\Desktop\" + name;
            GameUtil.CreateDirectory(outName);
            byte[] bytes = GameUtil.DecompressBytes(File.ReadAllBytes(files[i]));
            File.WriteAllBytes(outName, bytes);
            EditorUtility.DisplayProgressBar("encrypt lua code...", name, (float)i / files.Length);
        }
        EditorUtility.ClearProgressBar();
        AssetDatabase.Refresh();
    }


    static void ReimportDll(string path)
    {
        if (File.Exists(path))
            AssetDatabase.ImportAsset(path, ImportAssetOptions.ForceUpdate | ImportAssetOptions.DontDownloadFromCacheServer);
        else
            Debug.LogError(string.Format("DLL not found {0}", path));
    }

    static void GenerateAssetInfoJson()
    {
        try
        {
            BuildSetting bs = GetBuildSettingAsset();
            string path = Application.dataPath.Replace("Assets", "") + bs.buildPath;
            path = path.Replace('/', '\\');
            string[] files = Directory.GetFiles(path, "*", SearchOption.AllDirectories);
            Dictionary<string, object> dic = new Dictionary<string, object>();
            List<object> list = new List<object>();
            int fileCount = 0;
            long totalSize = 0;
            foreach (string file in files)
            {
                if (file.EndsWith(".meta") || file.EndsWith("AssetsInfo.xml") || file.EndsWith("AssetsInfo.json")) continue;
                string filePath = file.Replace('\\', '/');
                filePath = filePath.Replace(Application.dataPath + "/Build/", "");

                string md5 = GameUtil.MD5File(file);

                string fileName = Path.GetFileName(file);

                FileInfo info = new FileInfo(file);

                string size = info.Length.ToString();

                fileCount++;
                totalSize += info.Length;

                Dictionary<string, object> item = new Dictionary<string, object>();
                item.Add("name", fileName);
                item.Add("path", filePath);
                item.Add("md5", md5);
                item.Add("size", size);
                list.Add(item);

                EditorUtility.DisplayProgressBar("generate AssetsInfo.json", filePath, (float)fileCount / files.Length * 2);
            }
            Dictionary<string, object> infoDict = new Dictionary<string, object>();
            infoDict.Add("fileCount", fileCount.ToString());
            infoDict.Add("totalSize", totalSize.ToString());
            infoDict.Add("resVertion", bs.resVersion.ToString());
            infoDict.Add("generateTime", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
            dic.Add("info", infoDict);
            dic.Add("files", list);
            File.WriteAllText(path + "AssetsInfo.json", Json.Serialize(dic));
        }
        catch (System.Exception ex)
        {
            throw new Exception(ex.Message);
        }
        finally
        {
            EditorUtility.ClearProgressBar();
            AssetDatabase.Refresh();
        }
    }

    static void GenerateAssetInfoXml()
    {
        try
        {
            BuildSetting bs = GetBuildSettingAsset();
            string path = Application.dataPath.Replace("Assets", "") + bs.buildPath;
            path = path.Replace('/', '\\');
            string[] files = Directory.GetFiles(path, "*", SearchOption.AllDirectories);
            XmlDocument doc = new XmlDocument();
            XmlElement root = doc.CreateElement("root");
            int fileCount = 0;
            long totalSize = 0;
            doc.AppendChild(root);
            foreach (string file in files)
            {
                if (file.EndsWith(".meta") || file.EndsWith("AssetsInfo.xml") || file.EndsWith("AssetsInfo.txt")) continue;
                string filePath = file.Replace('\\', '/');
                filePath = filePath.Replace(Application.dataPath + "/Build/", "");

                string md5 = GameUtil.MD5File(file);

                string fileName = Path.GetFileName(file);

                FileInfo info = new FileInfo(file);

                string size = info.Length.ToString();

                XmlElement node = doc.CreateElement("file");

                XmlAttribute nameAtt = doc.CreateAttribute("name");
                nameAtt.Value = fileName;
                node.Attributes.Append(nameAtt);

                XmlAttribute pathAtt = doc.CreateAttribute("path");
                pathAtt.Value = filePath;
                node.Attributes.Append(pathAtt);

                XmlAttribute md5Att = doc.CreateAttribute("md5");
                md5Att.Value = md5;
                node.Attributes.Append(md5Att);

                XmlAttribute sizeAtt = doc.CreateAttribute("size");
                sizeAtt.Value = size;
                node.Attributes.Append(sizeAtt);

                root.AppendChild(node);

                fileCount++;
                totalSize += info.Length;

                EditorUtility.DisplayProgressBar("generate AssetsInfo.xml", filePath, (float)fileCount / files.Length * 2);
            }

            XmlAttribute fileCountAtt = doc.CreateAttribute("fileCount");
            fileCountAtt.Value = fileCount.ToString();
            root.Attributes.Append(fileCountAtt);

            XmlAttribute totalSizeAtt = doc.CreateAttribute("totalSize");
            totalSizeAtt.Value = totalSize.ToString();
            root.Attributes.Append(totalSizeAtt);

            XmlAttribute resVersionAtt = doc.CreateAttribute("resVertion");
            resVersionAtt.Value = bs.resVersion.ToString();
            root.Attributes.Append(resVersionAtt);

            XmlAttribute timeAtt = doc.CreateAttribute("generateTime");
            timeAtt.Value = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
            root.Attributes.Append(timeAtt);

            doc.Save(path + "AssetsInfo.xml");
        }
        catch (System.Exception ex)
        {
            throw new Exception(ex.Message);
        }
        finally
        {
            EditorUtility.ClearProgressBar();
            AssetDatabase.Refresh();
        }
    }

    static void Build()
    {
        BuildSetting bs = GetBuildSettingAsset();
        string buildPath = Application.dataPath.Replace("/Assets", "/") + bs.buildPath;
        DirectoryInfo di = new DirectoryInfo(buildPath);
        if (!di.Exists) di.Create();
        BuildPipeline.BuildAssetBundles(bs.buildPath, BuildAssetBundleOptions.UncompressedAssetBundle | BuildAssetBundleOptions.DeterministicAssetBundle, bs.buildTarget);
        AssetDatabase.RemoveUnusedAssetBundleNames();
        AssetDatabase.Refresh();
        GenerateAssetInfoJson();
    }

    /// <summary>
    /// 生成AssetBundle的标签
    /// 路径以Assets/开头
    /// </summary>
    /// <param name="path"></param>
    /// <returns></returns>
    static string GetAssetBundleTag(string path)
    {
        return GameUtil.GetAssetBundleTag(path);
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

        ((BuildSetting)obj).resVersion = EditorPrefs.GetInt("BuildVersion");

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
        return PlayerSettings.GetScriptingDefineSymbolsForGroup(EditorUserBuildSettings.selectedBuildTargetGroup).Split(';').ToList().Contains(str);
    }
}
