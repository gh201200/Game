﻿using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading;
using SLua;

[CustomLuaClass]
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

[CustomLuaClass]
public class AssetLoader : MonoBehaviour
{
    public double Progress
    {
        get
        {
            if (totalIndex > 0)
            {
                double p = (double)curIndex / totalIndex;
                return Math.Round(p, 2);
            }
            return 0f;
        }
    }

    public AssetDesc CurLoad { get; private set; }

    private static AssetLoader _instance;

    private AssetBundleManifest manifest;

    private Dictionary<string, AssetDesc> loadingDict = new Dictionary<string, AssetDesc>();

    private Dictionary<string, AssetBundleRequest> mainAssetLoadingDict = new Dictionary<string, AssetBundleRequest>();

    private Dictionary<string, System.Collections.Generic.List<Action<object>>> callbackDict = new Dictionary<string, System.Collections.Generic.List<Action<object>>>();

    private Dictionary<string, object> cacheDict = new Dictionary<string, object>();

    private Dictionary<string, BundleDes> abTemp = new Dictionary<string, BundleDes>();

    private Queue<string> abUnloadQueAsync = new Queue<string>();

    private bool ready = true;

    private long curIndex = 0;
    private long totalIndex = 0;

    public static AssetLoader Instance
    {
        get
        {
            if (_instance == null)
            {
                _instance = Root.Instance.gameObject.AddComponent<AssetLoader>();
                //print(_instance.Manifest.name);
            }
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
                if (manifest == null)
                {
                    AssetBundle ab = AssetBundle.LoadFromMemory(buffer);
                    manifest = ab.LoadAsset("AssetBundleManifest") as AssetBundleManifest;
                    ab.Unload(false);
                }
            }
            return manifest;
        }
    }

    public void Clear()
    {
        manifest = null;
        loadingDict = new Dictionary<string, AssetDesc>();
        mainAssetLoadingDict = new Dictionary<string, AssetBundleRequest>();
        callbackDict = new Dictionary<string, List<Action<object>>>();
        cacheDict = new Dictionary<string, object>();
        foreach (var o in abTemp)
        {
            if (o.Value.assetBundleReq.assetBundle != null) o.Value.assetBundleReq.assetBundle.Unload(false);
        }
        abTemp = new Dictionary<string, BundleDes>();
        abUnloadQueAsync = new Queue<string>();
    }

    public void LoadAsync(string file, AssetType at, Action<object> callback, Action<double> progress)
    {
        AssetDesc des = new AssetDesc(file, at);
        if (!File.Exists(des.ProjectPath))
        {
            Debug.LogError(des.ProjectPath + " is not exists!");
            return;
        }
        des.OnProgress = progress;
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
        if (!loadingDict.ContainsKey(file))
        {
            loadingDict.Add(file, des);
            totalIndex++;
            foreach (string str in des.Dependencies)
            {
                if (!abTemp.ContainsKey(str))
                {
                    string fullPath = Config.AssetPath + "res/" + str.Substring(4);
                    AssetBundleCreateRequest request = AssetBundle.LoadFromFileAsync(fullPath);
                    abTemp.Add(str, new BundleDes(request, fullPath));
                }
                abTemp[str].AddRefrenceCount();
                totalIndex++;
            }
        }
        if (!callbackDict.ContainsKey(file)) callbackDict.Add(file, new System.Collections.Generic.List<Action<object>>());
        callbackDict[file].Add(callback);
#endif
    }

    public void LoadAsync(string file, AssetType at, Action<object> callback)
    {
        lock (this)
        {
            LoadAsync(file, at, callback, null);
        }
    }

    public object Load(string file, AssetType at)
    {
        lock (this)
        {
            AssetDesc des = new AssetDesc(file, at);
            if (cacheDict.ContainsKey(des.RelativePath))
            {
                object obj = cacheDict[des.RelativePath];
                return obj;
            }
#if DEBUG_MODE
        object temp = UnityEditor.AssetDatabase.LoadAssetAtPath("Assets/Res/" + file, GameUtil.GetAssetType(at));
        cacheDict.Add(des.RelativePath, temp);
        return temp;
#else
            object temp = null;
            string[] dependencies = Manifest.GetDirectDependencies(des.AssetBundleTag);
            AssetBundle[] array = new AssetBundle[dependencies.Length + 1];
            int index = 0;
            foreach (string str in dependencies)
            {
                string fullPath = Config.AssetPath + str;
                AssetBundle ab = AssetBundle.LoadFromFile(fullPath);
                array[index] = ab;
                index++;
            }
            AssetBundle aa = AssetBundle.LoadFromFile(des.FullPath);
            array[index] = aa;
            temp = aa.LoadAsset(des.AssetName, GameUtil.GetAssetType(des.AssetType));
            cacheDict.Add(des.RelativePath, temp);
            foreach (AssetBundle t in array)
            {
                //abTemp.Add(t)
            }
            if (callbackDict.ContainsKey(file))
            {
                foreach (var act in callbackDict[file])
                {
                    act(temp);
                }
                callbackDict[file] = new List<Action<object>>();
            }
            return temp;
#endif
        }
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
            Dictionary<string, AssetBundleCreateRequest> array = new Dictionary<string, AssetBundleCreateRequest>();
            int index = 0;
            foreach (string str in dependencies)
            {
                string fullPath = Config.AssetPath + str.Substring(4);
                AssetBundleCreateRequest request = AssetBundle.LoadFromFileAsync(fullPath);
                array.Add(str, request);
                index++;
            }
            //等待依赖加载完成
            foreach (var obj in array.Values)
            {
                yield return obj;
                curIndex++;
            }
            //异步加载目标AssetBundle
            AssetBundleCreateRequest re = AssetBundle.LoadFromFileAsync(des.FullPath);
            array.Add(des.RelativePath.ToLower(), re);
            yield return re;
            curIndex++;
            //从目标AssetBundle中异步加载资源
            AssetBundleRequest abre = re.assetBundle.LoadAssetAsync(des.AssetName, GameUtil.GetAssetType(des.AssetType));
            yield return abre;
            des.Asset = abre.asset;
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
            callbackDict[des.RelativePath] = new System.Collections.Generic.List<Action<object>>();
            foreach (var t in array)
            {
                t.Value.assetBundle.Unload(false);
            }
        }
        loadingDict = new Dictionary<string, AssetDesc>();
        ready = true;
    }

    private void Update()
    {
        //print(Progress + "    " + curIndex + "/" + totalIndex);
        //print(curIndex + "/" + totalIndex);

        //while (callbackToRemoveQue.Count > 0) callbackDict.Remove(callbackToRemoveQue.Dequeue());

        //if (!ready) return;
        //if (loadingDict.Count > 0)
        //{
        //    StartCoroutine(CoLoad());
        //}

        //if (Input.GetKeyDown(KeyCode.Q))
        //{
        //    Debug.Log("---------------abTemp-----------------");
        //    if (abTemp.Count != 0) foreach (var k in abTemp.Keys) Debug.Log(k);
        //    else Debug.Log("abTemp's count is 0");
        //    Debug.Log("----------------abTemp----------------");
        //    Debug.Log("----------------Cached----------------");
        //    if (cacheDict.Count != 0) foreach (var k in cacheDict.Keys) Debug.Log(k);
        //    else Debug.Log("abTemp's count is 0");
        //    Debug.Log("----------------Cached----------------");
        //}

        //if (Input.GetKey(KeyCode.W)) print(Progress * 100 + "%" + "\t" + curIndex + "/" + totalIndex);

        if (loadingDict.Count <= 0) return;

#if PerFile
        foreach (var p in loadingDict)
        {
            if (mainAssetLoadingDict.ContainsKey(p.Key)) continue;
            foreach (var tag in p.Value.Dependencies)
            {
                if (p.Value.LoadedDependencies.Contains(tag)) continue;
                if (abTemp.ContainsKey(tag))
                {
                    if (abTemp[tag].assetBundleReq.isDone)
                    {
                        p.Value.FinishNum++;
                        p.Value.LoadedDependencies.Add(tag);
                        curIndex++;
                    }
                }
                else
                {
                    Debug.LogError("dependence assets must preload!" + " assets: \n" + p.Value.RelativePath + "\ndependecies: \n" + tag);
                }
            }
            if (abTemp.ContainsKey(p.Key) && abTemp[p.Key].assetBundleReq.isDone)
            {
                if (!mainAssetLoadingDict.ContainsKey(p.Key))
                {
                    p.Value.FinishNum++;
                    var temp = abTemp[p.Key].assetBundleReq.assetBundle.LoadAssetAsync(p.Value.AssetName, GameUtil.GetAssetType(p.Value.AssetType));
                    mainAssetLoadingDict.Add(p.Key, temp);
                    abTemp[p.Key].AddRefrenceCount();
                    curIndex++;
                }
            }
            else
            {
                if (p.Value.FinishNum >= p.Value.Dependencies.Length && !abTemp.ContainsKey(p.Key))
                {
                    var req = AssetBundle.LoadFromFileAsync(p.Value.FullPath);
                    abTemp.Add(p.Key, new BundleDes(req, p.Value.FullPath));
                }
            }
            p.Value.Progress = (float)p.Value.FinishNum / (p.Value.Dependencies.Length + 1);
        }

        foreach (var p in mainAssetLoadingDict)
        {
            if (p.Value.isDone)
            {
                if (!cacheDict.ContainsKey(p.Key)) cacheDict.Add(p.Key, p.Value.asset);
                if (callbackDict.ContainsKey(p.Key))
                {
                    foreach (var cb in callbackDict[p.Key])
                    {
                        cb(p.Value.asset);
                    }
                    callbackDict[p.Key] = new List<Action<object>>();
                }
                else
                {
                    Debug.LogError(p.Key + " -> callback is none!");
                }
                abTemp[p.Key].ReduceRefrenceCount();
                if (abTemp[p.Key].refrenceCount <= 0) abUnloadQueAsync.Enqueue(p.Key);
                foreach (var key in loadingDict[p.Key].Dependencies)
                {
                    abTemp[key].ReduceRefrenceCount();
                    if (abTemp[key].refrenceCount <= 0) abUnloadQueAsync.Enqueue(key);
                }
            }
        }

        while (abUnloadQueAsync.Count > 0)
        {
            var str = abUnloadQueAsync.Dequeue();
            if (abTemp.ContainsKey(str))
            {
                abTemp[str].assetBundleReq.assetBundle.Unload(false);
                abTemp.Remove(str);
                //Debug.Log("remove from abTemp -> " + str);
            }
            if (loadingDict.ContainsKey(str))
            {
                loadingDict.Remove(str);
                //Debug.Log("remove from loadingDict -> " + str);
            }
            if (mainAssetLoadingDict.ContainsKey(str))
            {
                mainAssetLoadingDict.Remove(str);
                //Debug.Log("remove from mainAssetLoadingDict -> " + str);
            }
        }
#else
        foreach (var p in loadingDict)
        {
            if (mainAssetLoadingDict.ContainsKey(p.Key)) continue;
            foreach (var tag in p.Value.Dependencies)
            {
                if (p.Value.LoadedDependencies.Contains(tag)) continue;
                if (abTemp.ContainsKey(tag))
                {
                    if (abTemp[tag].assetBundleReq.isDone)
                    {
                        p.Value.FinishNum++;
                        p.Value.LoadedDependencies.Add(tag);
                        curIndex++;
                    }
                }
                else
                {
                    Debug.LogError("dependence assets must preload!" + " assets: \n" + p.Value.RelativePath + "\ndependecies: \n" + tag);
                }
            }
            if (abTemp.ContainsKey(p.Value.AssetBundleTag) && abTemp[p.Value.AssetBundleTag].assetBundleReq.isDone)
            {
                if (!mainAssetLoadingDict.ContainsKey(p.Key))
                {
                    p.Value.FinishNum++;
                    var temp = abTemp[p.Value.AssetBundleTag].assetBundleReq.assetBundle.LoadAssetAsync(p.Value.AssetName, GameUtil.GetAssetType(p.Value.AssetType));
                    mainAssetLoadingDict.Add(p.Key, temp);
                    abTemp[p.Value.AssetBundleTag].AddRefrenceCount();
                    curIndex++;
                }
            }
            else
            {
                if (p.Value.FinishNum >= p.Value.Dependencies.Length && !abTemp.ContainsKey(p.Value.AssetBundleTag))
                {
                    var req = AssetBundle.LoadFromFileAsync(p.Value.FullPath);
                    abTemp.Add(p.Value.AssetBundleTag, new BundleDes(req, p.Value.FullPath));
                }
            }
            p.Value.Progress = (float)p.Value.FinishNum / (p.Value.Dependencies.Length + 1);
        }

        foreach (var p in mainAssetLoadingDict)
        {
            if (p.Value.isDone)
            {
                if (!cacheDict.ContainsKey(p.Key)) cacheDict.Add(p.Key, p.Value.asset);
                if (callbackDict.ContainsKey(p.Key))
                {
                    foreach (var cb in callbackDict[p.Key])
                    {
                        cb(p.Value.asset);
                    }
                    callbackDict[p.Key] = new List<Action<object>>();
                }
                else
                {
                    Debug.LogError(p.Key + " -> callback is none!");
                }
                abUnloadQueAsync.Enqueue(p.Key);
                string tag = AssetDesc.GetAssetBundleTag(p.Key);
                abTemp[tag].ReduceRefrenceCount();
                if (abTemp[tag].refrenceCount <= 0) abUnloadQueAsync.Enqueue(tag);
                foreach (var key in loadingDict[p.Key].Dependencies)
                {
                    abTemp[key].ReduceRefrenceCount();
                    if (abTemp[key].refrenceCount <= 0) abUnloadQueAsync.Enqueue(key);
                }
            }
        }

        while (abUnloadQueAsync.Count > 0)
        {
            var str = abUnloadQueAsync.Dequeue();
            if (abTemp.ContainsKey(str))
            {
                abTemp[str].assetBundleReq.assetBundle.Unload(false);
                abTemp.Remove(str);
                //Debug.Log("remove from abTemp -> " + str);
            }
            if (loadingDict.ContainsKey(str))
            {
                loadingDict.Remove(str);
                //Debug.Log("remove from loadingDict -> " + str);
            }
            if (mainAssetLoadingDict.ContainsKey(str))
            {
                mainAssetLoadingDict.Remove(str);
                //Debug.Log("remove from mainAssetLoadingDict -> " + str);
            }
        }
#endif
    }

    private class BundleDes
    {
        public string fullName;
        public AssetBundleCreateRequest assetBundleReq;
        public int refrenceCount;

        public void AddRefrenceCount()
        {
            refrenceCount++;
        }

        public void ReduceRefrenceCount()
        {
            refrenceCount--;
        }

        public BundleDes(AssetBundleCreateRequest req, string fullName)
        {
            this.assetBundleReq = req;
            this.fullName = fullName;
            refrenceCount = 0;
        }
    }
}
