using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using Object = UnityEngine.Object;

/// <summary>
/// 资源描述
/// </summary>
public class AssetDesc
{
    /// <summary>
    /// 资源名称带后缀
    /// </summary>
    public string AssetName { get; private set; }

    /// <summary>
    /// AssetBundle名称
    /// </summary>
    public string AssetBundleTag { get; private set; }

    /// <summary>
    /// 资源相对路径
    /// </summary>
    public string RelativePath { get; private set; }

    /// <summary>
    /// 资源相对路径无后缀名
    /// </summary>
    public string RelativePathWithoutSuffix { get; private set; }

    /// <summary>
    /// 以Assets开头的路径
    /// </summary>
    public string EditorPath { get; private set; }

    /// <summary>
    /// AssetBundle完整路径
    /// </summary>
    public string FullPath { get; private set; }

    /// <summary>
    /// 资源类型
    /// </summary>
    public AssetType AssetType { get; private set; }

    /// <summary>
    /// 资源
    /// </summary>
    public object Asset { get; set; }

    private double progress = 0f;

    /// <summary>
    /// 加载进度
    /// </summary>
    public double Progress
    {
        get { return progress; }
        set
        {
            progress = value;
            if (OnProgress != null) OnProgress(Math.Round(progress, 2));
        }
    }

    /// <summary>
    /// 资源是否已经成功加载
    /// </summary>
    public bool Success { get; private set; }

    /// <summary>
    /// 已加载完的依赖数量
    /// </summary>
    public int FinishNum { get; set; }

    /// <summary>
    /// 已完成加载的依赖
    /// </summary>
    public HashSet<string> LoadedDependencies { get; set; }

    public Action<double> OnProgress { get; set; }

    /// <summary>
    /// 依赖列表
    /// </summary>
    public string[] Dependencies { get; private set; }

    public AssetDesc(string path, AssetType at)
    {
        Progress = 0f;
        Success = false;
        EditorPath = "Assets/Res/" + path;
        AssetName = Path.GetFileName(path);
        AssetBundleTag = GameUtil.GetAssetBundleTag(EditorPath);
        RelativePath = path;
        int index = RelativePath.LastIndexOf('.');
        RelativePathWithoutSuffix = "res/" + RelativePath.Substring(0, index).ToLower() + ".bytes";
        FullPath = Config.AssetPath + AssetBundleTag.Substring(4);
        AssetType = at;
        Dependencies = AssetLoader.Instance.Manifest.GetDirectDependencies(AssetBundleTag);
        LoadedDependencies = new HashSet<string>();
        FinishNum = 0;
    }
}
