using UnityEngine;
using System.Collections;
using SLua;

[CustomLuaClass]
public class Config
{
    public static bool test = false;
    /// <summary>
    /// 资源加载路径根目录
    /// </summary>
    public static string AssetPath
    {
        get
        {
#if DEBUG_MODE
            return Application.dataPath + "/";
#else
#if LOADABFROMPROJECT
            return Application.dataPath + "/Build/";
#else
            return Application.persistentDataPath + "/";
#endif
#endif
        }
    }

    /// <summary>
    /// Lua加载根目录
    /// </summary>
    public static string LuaPath
    {
        get
        {
#if DEBUG_MODE
            return Application.dataPath + "/LuaScripts/";
#else
#if LOADABFROMPROJECT
            return Application.dataPath + "/Build/LuaScripts/";
#else
            return Application.persistentDataPath + "/LuaScripts/";
#endif
#endif
        }
    }

    /// <summary>
    /// StreamingAssets Path
    /// </summary>
    public static string StreamingAssetsPath
    {
        get
        {
            switch (Application.platform)
            {
                case RuntimePlatform.WindowsPlayer:
                case RuntimePlatform.OSXPlayer:
                case RuntimePlatform.OSXEditor:
                case RuntimePlatform.WindowsEditor:
                    return Application.dataPath + "/StreamingAssets";
                case RuntimePlatform.IPhonePlayer:
                    return Application.dataPath + "/Raw";
                case RuntimePlatform.Android:
                    return "jar:file://" + Application.dataPath + "!/assets";
            }
            return null;
        }
    }
}
