using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text;
using NPOI.HSSF.UserModel;
using NPOI.SS.UserModel;
using NPOI.XSSF.UserModel;
using UnityEditor;

public class AnalyseExcelWindow : EditorWindow
{
    private enum ExportType
    {
        Lua = 1,
        Json = 2,
        Xml = 4,
    }

    private static Vector2 pos;

    private static string ExcelRootPath
    {
        get { return EditorPrefs.GetString("ExcelRootPath", ""); }
        set { EditorPrefs.SetString("ExcelRootPath", value); }
    }

    private static string ConfigSavePath
    {
        get { return EditorPrefs.GetString("ConfigSavePath", ""); }
        set { EditorPrefs.SetString("ConfigSavePath", value); }
    }

    private static ExportType exportType;

    private void OnGUI()
    {
        pos = EditorGUILayout.BeginScrollView(pos);
        EditorGUILayout.Separator();
        EditorGUILayout.BeginHorizontal();
        EditorGUILayout.SelectableLabel(ExcelRootPath);
        if (GUILayout.Button("excel path"))
        {
            var path = EditorUtility.OpenFolderPanel("Excel路径", ExcelRootPath, "");
            if (path.Length > 0) ExcelRootPath = path;
        }
        EditorGUILayout.EndHorizontal();

        EditorGUILayout.Separator();
        EditorGUILayout.BeginHorizontal();
        EditorGUILayout.SelectableLabel(ConfigSavePath);
        if (GUILayout.Button("save path"))
        {
            var path = EditorUtility.OpenFolderPanel("保存路径", ConfigSavePath, "");
            if (path.Length > 0) ConfigSavePath = path;
        }
        EditorGUILayout.EndHorizontal();

        //EditorGUILayout.Separator();
        //EditorGUILayout.BeginHorizontal();
        //exportType = (ExportType)EditorGUILayout.EnumMaskField("export type", exportType);
        //EditorGUILayout.EndHorizontal();

        EditorGUILayout.Separator();
        EditorGUILayout.BeginHorizontal();
        if (GUILayout.Button("export lua code"))
        {
            //int allIndex = 0;

            //foreach (int e in Enum.GetValues(typeof(ExportType)))
            //{
            //    allIndex |= e;
            //}

            //int resIndex = (int)exportType & allIndex;

            if (string.IsNullOrEmpty(ExcelRootPath) || string.IsNullOrEmpty(ConfigSavePath))
            {
                EditorUtility.DisplayDialog("提示", "路径不完整！", "确定");
                return;
            }

            ExportConfig();
        }
        EditorGUILayout.EndHorizontal();
        GUILayout.EndScrollView();
    }

    private void ExportConfig()
    {
        var files = Directory.GetFiles(ExcelRootPath, "*", SearchOption.AllDirectories);
        var curNum = 0;
        var totalNum = 0;
        foreach (var file in files)
        {
            if (!file.EndsWith(".xls") && !file.EndsWith(".xlsx")) continue;
            totalNum++;
        }
        try
        {
            foreach (var file in files)
            {
                Hashtable desDic = new Hashtable();
                Hashtable fieldDic = new Hashtable();
                Hashtable typeDic = new Hashtable();
                Dictionary<int, Hashtable> valueDic = new Dictionary<int, Hashtable>();
                EditorUtility.DisplayProgressBar("正在导出配置", file, (float)curNum / totalNum);
                if (!file.EndsWith(".xls") && !file.EndsWith(".xlsx")) continue;
                using (var fs = new FileStream(file, FileMode.Open))
                {
                    ISheet sheet = null;
                    if (file.EndsWith(".xls"))
                    {
                        HSSFWorkbook book = new HSSFWorkbook(fs);
                        sheet = book.GetSheetAt(0);
                    }
                    if (file.EndsWith(".xlsx"))
                    {
                        XSSFWorkbook book2 = new XSSFWorkbook(fs);
                        sheet = book2.GetSheetAt(0);
                    }
                    if (sheet == null)
                    {
                        EditorUtility.DisplayDialog("提示", "解析错误！文件格式不支持！", "Fuck");
                        return;
                    }
                    for (int i = 0; i <= sheet.LastRowNum; i++)
                    {
                        IRow row = sheet.GetRow(i);
                        if (row.GetCell(0) == null || string.IsNullOrEmpty(row.GetCell(0).ToString())) continue;
                        var entry = new Hashtable();
                        for (int j = 0; j <= row.LastCellNum; j++)
                        {
                            ICell cell = row.GetCell(j);
                            if (cell == null || string.IsNullOrEmpty(cell.ToString())) continue;
                            cell.SetCellType(CellType.String);
                            if (i == 0)
                            {
                                desDic[j] = cell.ToString();
                            }
                            else if (i == 1)
                            {
                                fieldDic[j] = cell.ToString();
                            }
                            else if (i == 2)
                            {
                                typeDic[j] = cell.ToString();
                            }
                            else
                            {
                                entry[j] = cell.ToString();
                            }
                        }
                        if (i > 2)
                        {
                            valueDic.Add(i, entry);
                        }
                    }
                    var sb = new StringBuilder();
                    for (int i = 0; i < desDic.Count; i++)
                    {
                        var desStr = desDic[i] as string;
                        var fieldStr = fieldDic[i] as string;
                        sb.Append("-- " + fieldStr + "\t:\t" + desStr + "\n");
                    }
                    sb.Append("return {\n");
                    foreach (var o in valueDic)
                    {
                        Hashtable p = o.Value;
                        var id = p[0];
                        sb.Append("\t");
                        sb.Append("[" + id + "] = {\n");
                        var error = false;
                        for (int i = 0; i < fieldDic.Count; i++)
                        {
                            var fieldStr = fieldDic[i] as string;
                            var typeStr = typeDic[i] as string;
                            var valueStr = p[i] as string;
                            if (fieldStr == null)
                            {
                                if (!error)
                                {
                                    Debug.Log("存在空的列。文件名：" + file + "\n表名：" + sheet.SheetName + "\n列数：" + i + 1);
                                    error = true;
                                }
                                continue;
                            }
                            sb.Append("\t\t");
                            sb.Append("[\"" + fieldStr + "\"]" + " = ");
                            string value = "";
                            switch (typeStr)
                            {
                                case "number":
                                case "table":
                                case "bool":
                                    value = valueStr;
                                    break;
                                case "string":
                                    value = "\"" + valueStr + "\"";
                                    break;
                                default:
                                    Debug.LogError("不支持的数据类型：" + typeStr);
                                    return;
                            }
                            sb.Append(value + ",\n");
                        }
                        sb.Append("\t},\n");
                    }
                    sb.Append("}");
                    File.WriteAllText(ConfigSavePath + "/" + sheet.SheetName + ".lua", sb.ToString());
                    curNum++;
                }
            }
        }
        catch (Exception e)
        {
            Debug.LogError(e.Message + "\n" + e.StackTrace);
            AssetDatabase.Refresh();
            EditorUtility.ClearProgressBar();
        }
        AssetDatabase.Refresh();
        EditorUtility.ClearProgressBar();
    }
}
