using UnityEngine;
using System.Collections;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;
using UnityEditor;
using UnityEditor.ProjectWindowCallback;

public class LuaCreate
{
    private static string luaModelPath = Application.dataPath + "/Editor/LuaModel/NewLuaScript.lua";

    /// <summary>
    /// 创建Lua脚本
    /// </summary>
    [MenuItem("Assets/Create/Lua Script", false, 81)]
    static void CreateLuaScript()
    {
        ProjectWindowUtil.StartNameEditingIfProjectWindowExists(0,
        ScriptableObject.CreateInstance<MyDoCreateScriptAsset>(),
        "NewLuaScript.lua",
        null,
       luaModelPath);
    }
}


class MyDoCreateScriptAsset : EndNameEditAction
{
    public override void Action(int instanceId, string pathName, string resourceFile)
    {
        pathName = pathName.Replace('\\', '/');
        UnityEngine.Object o = CreateScriptAssetFromTemplate(pathName, resourceFile);
        ProjectWindowUtil.ShowCreatedAsset(o);

        string path = Path.GetFullPath(AssetDatabase.GetAssetPath(Selection.activeObject));
        path = path.Replace("\\", "/");
        if (!path.Contains(Application.dataPath + "/LuaScripts"))
        {
            EditorUtility.DisplayDialog("提示", "只能在路径Assets/LuaScripts下创建Lua脚本！！！", "卧槽！");
            File.Delete(path);
            File.Delete(path + ".meta");
            AssetDatabase.Refresh();
            return;
        }
    }

    internal static UnityEngine.Object CreateScriptAssetFromTemplate(string pathName, string resourceFile)
    {
        string fullPath = Path.GetFullPath(pathName);
        StreamReader streamReader = new StreamReader(resourceFile);
        string text = streamReader.ReadToEnd();
        streamReader.Close();
        string fileNameWithoutExtension = Path.GetFileNameWithoutExtension(pathName);
        text = Regex.Replace(text, "#NewLuaScript#", fileNameWithoutExtension);
        bool encoderShouldEmitUTF8Identifier = true;
        bool throwOnInvalidBytes = false;
        UTF8Encoding encoding = new UTF8Encoding(encoderShouldEmitUTF8Identifier, throwOnInvalidBytes);
        bool append = false;
        StreamWriter streamWriter = new StreamWriter(fullPath, append, encoding);
        streamWriter.Write(text);
        streamWriter.Close();
        AssetDatabase.ImportAsset(pathName);
        return AssetDatabase.LoadAssetAtPath(pathName, typeof(UnityEngine.Object));
    }

}
