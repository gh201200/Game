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
    private static bool debugMode = PreDebugMode;

    private static bool preDebugMode = true;

    private bool firstInit = true;

    private const string debugStr = "DEBUG_MODE";

    private const string perFileStr = "PerFile";

    private bool perFile = prePerFile;

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

    private static bool prePerFile
    {
        get { return GameEditor.ExistsSymbols(perFileStr); }
        set
        {
            if (value)
            {
                GameEditor.AddSymbols(perFileStr);
            }
            else
            {
                GameEditor.RemoveSymbols(perFileStr);
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
        perFile = GUILayout.Toggle(perFile, "    Pack AssetBundle PerFile");
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
            if (debugMode != PreDebugMode || perFile != prePerFile)
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
            firstInit = true;
        }
        if (firstInit)
        {
            firstInit = false;
            debugMode = PreDebugMode;
            perFile = prePerFile;
        }
        return base.RequiresConstantRepaint();
    }

    private void OnApply()
    {
        PreDebugMode = debugMode;
        prePerFile = perFile;
    }

    private void OnRevert()
    {
        debugMode = PreDebugMode;
        perFile = prePerFile;
    }
}
