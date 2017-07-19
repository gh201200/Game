using UnityEngine;
using System.Collections;
using System.IO;
using UnityEditor;

public class GameEditor
{
    [MenuItem("Tool/Test", false, 0)]
    static void Test()
    {
        string url = @"http://localhost/ShareFolder/test.sql";
        using (WWW www = new WWW(url))
        {

        }
    }
}
