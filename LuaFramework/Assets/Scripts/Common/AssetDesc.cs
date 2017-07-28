using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using Object = UnityEngine.Object;

/// <summary>
/// 资源描述
/// </summary>
public class AssetDesc : MonoBehaviour
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

    /// <summary>
    /// 加载进度
    /// </summary>
    public float Progress { get; set; }

    /// <summary>
    /// 资源是否已经成功加载
    /// </summary>
    public bool Success { get; private set; }

    public AssetDesc(string path, AssetType at)
    {
        Progress = 0f;
        Success = false;
        EditorPath = "Assets/Res/" + path;
        AssetName = Path.GetFileName(path);
        AssetBundleTag = GameUtil.GetAssetBundleTag(EditorPath);
        RelativePath = path;
        FullPath = Config.AssetPath + AssetBundleTag.Replace("res/", "");
        AssetType = at;
    }
}
