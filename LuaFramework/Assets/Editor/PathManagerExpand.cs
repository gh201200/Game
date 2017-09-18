using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.Globalization;
using System.IO;
using UnityEditor;
using MiniJSON;
using Debug = UnityEngine.Debug;

[CustomEditor(typeof(PathManager))]
public class PathManagerExpand : Editor
{
    public override void OnInspectorGUI()
    {
        base.OnInspectorGUI();
        EditorGUILayout.Separator();
        GUILayout.BeginHorizontal();
        EditorGUILayout.SelectableLabel(PathRecoder.ObstacleRoot);
        if (GUILayout.Button("选择障碍物路径"))
        {
            var path = EditorUtility.OpenFolderPanel("障碍物路径", PathRecoder.ObstacleRoot, "");
            path = path.Replace('\\', '/');
            if (!path.StartsWith(Application.dataPath + "/Res"))
            {
                EditorUtility.DisplayDialog("提示", "障碍物路径必须以Assets/Res开头", "确定");
                return;
            }
            if (path.Length > 0) PathRecoder.ObstacleRoot = path;
        }
        GUILayout.EndHorizontal();

        //GUILayout.BeginHorizontal();
        //EditorGUILayout.SelectableLabel(PathRecoder.EntityRoot);
        //if (GUILayout.Button("选择Entity路径"))
        //{
        //    var path = EditorUtility.OpenFolderPanel("Entity路径", PathRecoder.EntityRoot, "");
        //    path = path.Replace('\\', '/');
        //    if (!path.StartsWith(Application.dataPath + "/Res"))
        //    {
        //        EditorUtility.DisplayDialog("提示", "Entity路径必须以Assets/Res开头", "确定");
        //        return;
        //    }
        //    if (path.Length > 0) PathRecoder.EntityRoot = path;
        //}
        //GUILayout.EndHorizontal();

        if (GUILayout.Button("生成标签"))
        {
            GenerateObstacleTag();
        }
        if (GUILayout.Button("导出障碍物信息"))
        {
            ExportMapObjConfig();
        }
        if (GUILayout.Button("导出网格信息"))
        {
            ExportMapGridConfig();
        }
        //if (GUILayout.Button("导出Entity信息"))
        //{
        //    ExportMapEntityConfig();
        //}

        if (GUILayout.Button("清除缓存"))
        {
            PathManager m = target as PathManager;
            m.Clear();
        }
        EditorGUILayout.Separator();
        if (GUILayout.Button("寻路(TEST)"))
        {
            PathManager m = target as PathManager;
            m.curPath = m.FindPath(m.startPos.transform.position, m.endPos.transform.position);
        }
    }

    private void GenerateObstacleTag()
    {
        GameEditor.RemoveAllTag();
        //var entitys = Directory.GetFiles(PathRecoder.EntityRoot, "*", SearchOption.AllDirectories);
        var obstacles = Directory.GetFiles(PathRecoder.ObstacleRoot, "*", SearchOption.AllDirectories);
        var files = new List<string>();
        //files.AddRange(entitys);
        files.AddRange(obstacles);
        foreach (var file in files)
        {
            var fullPath = file.Replace('\\', '/');
            if (fullPath.EndsWith(".meta")) continue;
            var tag = fullPath.Replace(Application.dataPath + "/", "");
            var path = "Assets/" + tag;
            var assets = AssetDatabase.LoadAssetAtPath<GameObject>(path);
            GameEditor.AddTag(tag);
            assets.tag = tag;
            foreach (var t in assets.GetComponentsInChildren<Transform>(true))
            {
                t.tag = tag;
            }
        }
        Debug.Log("finish!");
    }

    private void ExportMapObjConfig()
    {
        PathManager m = target as PathManager;
        if (m == null) return;
        var table = m.GetObjList();
        if (table == null) return;

        var temp = EditorUtility.OpenFolderPanel("保存路径", PathRecoder.MapObjConfigPath, "");
        if (string.IsNullOrEmpty(temp)) return;
        temp = temp.Replace('\\', '/');
        if (!temp.StartsWith(Application.dataPath + "/Res"))
        {
            EditorUtility.DisplayDialog("提示", "保存路径必须以Assets/Res开头", "确定");
            return;
        }
        PathRecoder.MapObjConfigPath = temp;

        Dictionary<string, object> assetsDic = new Dictionary<string, object>();
        foreach (DictionaryEntry o in table)
        {
            List<Dictionary<string, object>> itemList = new List<Dictionary<string, object>>();
            var path = o.Key as string;
            var item = o.Value as Hashtable;
            foreach (DictionaryEntry de in item)
            {
                if (de.Key != null)
                {
                    var info = de.Value as Hashtable;
                    if (info == null)
                    {
                        Debug.LogError("nuknow exception!");
                        return;
                    }
                    var position = (Vector3)info["position"];
                    var eulerAngles = (Vector3)info["eulerAngles"];
                    var scale = (Vector3)info["scale"];
                    Dictionary<string, object> entry = new Dictionary<string, object>();
                    entry.Add("position", position.x + "," + position.y + "," + position.z);
                    entry.Add("eulerAngles", eulerAngles.x + "," + eulerAngles.y + "," + eulerAngles.z);
                    entry.Add("scale", scale.x + "," + scale.y + "," + scale.z);
                    itemList.Add(entry);
                }
            }
            assetsDic.Add(path, itemList);
        }
        var json = Json.Serialize(assetsDic);
        File.WriteAllText(PathRecoder.MapObjConfigPath + "/MapObjConfig.json", json);
        Process.Start(PathRecoder.MapObjConfigPath);
    }

    private void ExportMapGridConfig()
    {
        PathManager m = target as PathManager;
        if (m == null) return;
        var temp = EditorUtility.OpenFolderPanel("保存路径", PathRecoder.MapGridConfigPath, "");
        if (string.IsNullOrEmpty(temp)) return;
        temp = temp.Replace('\\', '/');
        if (!temp.StartsWith(Application.dataPath + "/Res"))
        {
            EditorUtility.DisplayDialog("提示", "保存路径必须以Assets/Res开头", "确定");
            return;
        }
        PathRecoder.MapGridConfigPath = temp;
        var grids = m.GetGridList();
        if (grids != null && grids.Length > 0)
        {
            Dictionary<string, object> gridDic = new Dictionary<string, object>();
            foreach (var grid in grids)
            {
                var key = grid.X + "-" + grid.Y;
                Dictionary<string, object> entry = new Dictionary<string, object>();
                entry.Add("X", grid.X);
                entry.Add("Y", grid.Y);
                entry.Add("position", grid.Pos.x + "," + grid.Pos.y + "," + grid.Pos.z);
                entry.Add("IsWall", grid.IsWall);
                gridDic.Add(key, entry);
            }
            Dictionary<string, object> desDic = new Dictionary<string, object>();
            desDic.Add("gridSize", m.gridSize);
            desDic.Add("xCount", m.xCount);
            desDic.Add("yCount", m.yCount);
            desDic.Add("gridThreshold", m.gridThreshold);
            desDic.Add("obstacleLayer", m.obstacleLayer.value);
            Dictionary<string, object> dic = new Dictionary<string, object>();
            dic.Add("des", desDic);
            dic.Add("grids", gridDic);
            var json = Json.Serialize(dic);
            File.WriteAllText(PathRecoder.MapGridConfigPath + "/MapGridConfig.json", json);
            Process.Start(PathRecoder.MapGridConfigPath);
        }
    }
}
