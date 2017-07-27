using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;

public enum AssetType
{
    Sprite,
    Texture2D,
    TextAsset,
    AudioClip,
    AnimationClip,
    Font,
    Material,
    Prefab,
    Scene,
    None,
}

public class AssetLoader : MonoBehaviour
{
    public float Progress
    {
        get
        {
            if (totalIndex > 0)
            {
                double p = (double)curIndex / totalIndex;
                return (float)Math.Round(p, 2);
            }
            return 0f;
        }
    }

    public AssetDesc CurLoad { get; private set; }

    private static AssetLoader _instance;

    private AssetBundleManifest manifest;

    private Dictionary<string, AssetDesc> loadingDict = new Dictionary<string, AssetDesc>();

    private Dictionary<string, List<Action<object>>> callbackDict = new Dictionary<string, List<Action<object>>>();

    private Dictionary<string, object> cacheDict = new Dictionary<string, object>();

    private Dictionary<DateTime, List<AssetBundleCreateRequest>> abToUnload = new Dictionary<DateTime, List<AssetBundleCreateRequest>>();

    private Queue<string> callbackToRemoveQue = new Queue<string>();

    private Queue<DateTime> que = new Queue<DateTime>();

    private bool ready = true;

    private int curIndex = 0;
    private int totalIndex = 0;

    public static AssetLoader Instance
    {
        get
        {
            if (_instance == null) _instance = Root.Instance.gameObject.AddComponent<AssetLoader>();
            return _instance;
        }
    }

    public AssetBundleManifest Manifest
    {
        get
        {
            if (manifest == null)
            {
                string path =
#if LOADABFROMPROJECT
                Application.dataPath + "/Build/Build".Replace('\\', '/');
#else
                Application.persistentDataPath + "/Build".Replace('\\', '/');
#endif
                if (!File.Exists(path))
                {
                    Debug.LogError(path + " is not found");
                    return null;
                }
                byte[] buffer = File.ReadAllBytes(path);
                AssetBundle ab = AssetBundle.LoadFromMemory(buffer);
                manifest = ab.LoadAsset("AssetBundleManifest") as AssetBundleManifest;
            }
            return manifest;
        }
    }

    public void ClearCache()
    {
        cacheDict = new Dictionary<string, object>();
    }

    public void Load(string file, AssetType at, Action<object> callback)
    {
        if (cacheDict.ContainsKey(file))
        {
            object obj = cacheDict[file];
            callback(obj);
            return;
        }
#if DEBUG_MODE
        object temp = UnityEditor.AssetDatabase.LoadAssetAtPath("Assets/Res/" + file, GameUtil.GetAssetType(at));
        cacheDict.Add(file, temp);
        callback(temp);
#else
        if (!loadingDict.ContainsKey(file)) loadingDict.Add(file, new AssetDesc(file, at));
        if (!callbackDict.ContainsKey(file)) callbackDict.Add(file, new List<Action<object>>());
        callbackDict[file].Add(callback);
#endif
    }

    private IEnumerator CoLoad()
    {
        ready = false;
        curIndex = 0;
        totalIndex = 0;
        foreach (var des in loadingDict.Values)
        {
            totalIndex += Manifest.GetDirectDependencies(des.AssetBundleTag).Length;
            totalIndex += 1;
        }
        foreach (var des in loadingDict.Values)
        {
            //异步加载所有依赖
            string[] dependencies = Manifest.GetDirectDependencies(des.AssetBundleTag);
            AssetBundleCreateRequest[] array = new AssetBundleCreateRequest[dependencies.Length + 1];
            int index = 0;
            foreach (string str in dependencies)
            {
                string fullPath = Config.AssetPath + str.Substring(4);
                AssetBundleCreateRequest request = AssetBundle.LoadFromFileAsync(fullPath);
                array[index] = request;
                index++;
            }
            //等待依赖加载完成
            for (int i = 0; i < index; i++)
            {
                yield return array[i].isDone;
                curIndex++;
            }
            //异步加载目标AssetBundle
            AssetBundleCreateRequest re = AssetBundle.LoadFromFileAsync(des.FullPath);
            array[index] = re;
            yield return re.isDone;
            curIndex++;
            //从目标AssetBundle中异步加载资源
            AssetBundleRequest abre = re.assetBundle.LoadAssetAsync(des.AssetName, GameUtil.GetAssetType(des.AssetType));
            yield return abre.isDone;
            des.Asset = abre.asset;
            Debug.Log(abre.asset);
            //添加资源到缓存
            if (!cacheDict.ContainsKey(des.RelativePath)) cacheDict.Add(des.RelativePath, des.Asset);
            //发布加载结束回调
            if (callbackDict[des.RelativePath] == null || callbackDict[des.RelativePath].Count <= 0)
            {
                Debug.LogError("loaded asset'callback is none");
                yield break;
            }
            foreach (var callback in callbackDict[des.RelativePath])
            {
                callback(des.Asset);
            }
            callbackToRemoveQue.Enqueue(des.RelativePath);
            //把已加载的AssetBundle添加到等待卸载列表中
            DateTime key = DateTime.Now.AddMilliseconds(500);
            if (!abToUnload.ContainsKey(key)) abToUnload.Add(key, new List<AssetBundleCreateRequest>());
            foreach (AssetBundleCreateRequest t in array)
            {
                abToUnload[key].Add(t);
            }
        }
        loadingDict = new Dictionary<string, AssetDesc>();
        ready = true;
    }

    private void Update()
    {
        while (callbackToRemoveQue.Count > 0) callbackDict.Remove(callbackToRemoveQue.Dequeue());
        if (abToUnload.Count > 0)
        {
            foreach (var p in abToUnload)
            {
                if (DateTime.Now >= p.Key)
                {
                    foreach (var re in p.Value)
                    {
                        Debug.Log("unload: " + re.assetBundle.GetAllAssetNames()[0]);
                        re.assetBundle.Unload(false);
                    }
                    que.Enqueue(p.Key);
                }
            }
            while (que.Count > 0)
            {
                abToUnload.Remove(que.Dequeue());
            }
        }
        if (!ready) return;
        if (loadingDict.Count > 0)
        {
            StartCoroutine_Auto(CoLoad());
        }
    }
}
