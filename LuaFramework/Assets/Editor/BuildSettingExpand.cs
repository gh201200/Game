using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEditorInternal;

[CustomEditor(typeof(BuildSetting))]
public class BuildSettingExpand : Editor
{
    private static bool debugMode = true;

    private static bool preDebugMode = true;

    private bool firstInit = false;

    private const string debugStr = "DEBUG_MODE";

    private string[] packType = { "PerFolder", "PerFile" };

    private int curPackType = -1;

    private static bool PreDebugMode
    {
        get { return GameEditor.ExistsSymbols(debugStr); }
        set
        {
            if (value)
            {
                GameEditor.AddSymbols(debugStr);
            }
            else
            {
                GameEditor.RemoveSymbols(debugStr);
            }
        }
    }

    public override void OnInspectorGUI()
    {
        base.OnInspectorGUI();
        if (EditorApplication.isCompiling) return;
        GUILayout.BeginVertical();
        EditorGUILayout.Separator();
        debugMode = GUILayout.Toggle(debugMode, "    Debug Mode");
        EditorGUILayout.Separator();
        curPackType = EditorGUILayout.Popup(curPackType, packType);
        if (curPackType == 1)
        {
            GameEditor.AddSymbols("PerFile");
        }
        else
        {
            GameEditor.RemoveSymbols("PerFile");
        }
        EditorGUILayout.Separator();
        GUILayout.BeginHorizontal();
        if (GUILayout.Button("Apply"))
        {
            OnApply();
        }
        if (GUILayout.Button("Revert"))
        {
            OnRevert();
        }
        GUILayout.EndHorizontal();
        GUILayout.EndVertical();
    }

    public override bool RequiresConstantRepaint()
    {
        if (EditorApplication.isCompiling) return false;
        if (Selection.activeObject == null)
        {
            if (debugMode != PreDebugMode)
            {
                bool ok = EditorUtility.DisplayDialog("提示", "use settings?", "Apply", "Revert");
                if (ok)
                {
                    OnApply();
                }
                else
                {
                    OnRevert();
                }
            }
            firstInit = false;
        }
        if (!firstInit)
        {
            firstInit = true;
            debugMode = PreDebugMode;
        }
        return base.RequiresConstantRepaint();
    }

    private void OnApply()
    {
        PreDebugMode = debugMode;
    }

    private void OnRevert()
    {
        debugMode = PreDebugMode;
    }
}
