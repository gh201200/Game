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
        try
        {
            int id = SLua.LuaTimer.add(1000, arg => Debug.Log("callback id: " + arg));
            Debug.Log("timer id: " + id);
        }
        catch (System.Exception ex)
        {
            Debug.LogError(ex);
        }
    }

    [MenuItem("Tool/BuildSetting", false, 0)]
    static void BuildSetting()
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
        EditorUtility.FocusProjectWindow();
        Selection.activeObject = obj;
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
