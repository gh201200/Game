using UnityEngine;
using System.Collections;

public class Config
{
    /// <summary>
    /// 资源加载路径根目录
    /// </summary>
    public static string AssetPath
    {
        get
        {
#if DEBUG_MODE
            return Application.dataPath + "/Res/";
#else
#if LOADABFROMPROJECT
            return Application.dataPath + "/Build/res/";
#else
            return Application.persistentDataPath + "/res/";
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
            return Application.persistentDataPath + "/LuaScripts/";
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
