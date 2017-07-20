using UnityEngine;
using System.Collections;
using UnityEditor;

public class BuildSetting : ScriptableObject
{
    [Header("APP版本号")]
    public int appVersion = 0;

    [Header("资源版本号")]
    public int resVersion = 0;

    [Header("Lua脚本根目录")]
    public string luaPath = "Assets/LuaScripts/";

    [Header("资源根目录")]
    public string resPath = "Assets/Res/";

    [Header("资源打包的目标路径")]
    public string buildPath = "Assets/Build/";

    [Header("AssetBundle目标平台")]
    public BuildTarget buildTarget = BuildTarget.StandaloneWindows;
}
