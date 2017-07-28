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
    private static bool debugMode;

    private static bool preDebugMode = true;

    private bool firstInit = true;

    private const string debugStr = "DEBUG_MODE";

    private const string perFileStr = "PerFile";

    private bool perFile;

    private bool loadABFromProject;

    private static bool PreLoadABFromProject
    {
        get { return GameEditor.ExistsSymbols("LOADABFROMPROJECT"); }
        set
        {
            if (value)
            {
                GameEditor.AddSymbols("LOADABFROMPROJECT");
            }
            else
            {
                GameEditor.RemoveSymbols("LOADABFROMPROJECT");
            }
        }
    }

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
        GUILayout.Space(8);
        GUI.enabled = !loadABFromProject;
        debugMode = GUILayout.Toggle(debugMode, "    Debug Mode");
        GUILayout.Space(8);
        GUI.enabled = true;
        perFile = GUILayout.Toggle(perFile, "    Pack AssetBundle PerFile");
        GUILayout.Space(8);
        GUI.enabled = !debugMode;
        loadABFromProject = GUILayout.Toggle(loadABFromProject, "    Load AB From Project");
        GUILayout.Space(8);
        GUI.enabled = true;
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
            if (debugMode != PreDebugMode || perFile != prePerFile || loadABFromProject != PreLoadABFromProject)
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
        PreLoadABFromProject = loadABFromProject;
    }

    private void OnRevert()
    {
        debugMode = PreDebugMode;
        perFile = prePerFile;
        loadABFromProject = PreLoadABFromProject;
    }

    private void OnEnable()
    {
        debugMode = PreDebugMode;
        loadABFromProject = PreLoadABFromProject;
        perFile = prePerFile;
    }
}
