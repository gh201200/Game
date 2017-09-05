using System;
using UnityEngine;
using System.Collections;
using System.IO;
using SLua;

public class Init : MonoBehaviour
{
    public float labelWidth = 200f;
    public float labelHeight = 80f;
    public int fontSize = 25;
    private bool complete = false;
    private string str = "初始化...0%";
    private GUIStyle style;

    private Action act;

    private AsyncArgs args;

    private string zipPath = "";

    private void Start()
    {
        act = () =>
        {
            LuaManager.Instance.Init(p =>
            {
                str = "初始化..." + p + "%";
            }, instance =>
            {
                instance["DEBUG_MODE"] =
#if DEBUG_MODE
            true;
#else
            false;
#endif
                complete = true;
                instance.DoFile("Main");
            });
        };

        var w = labelWidth / 1024;
        var h = labelHeight / 576;
        labelWidth = Screen.width * w;
        labelHeight = Screen.height * h;
        var f = fontSize / 1024f;
        fontSize = (int)(Screen.width * f);
        style = new GUIStyle();
        style.fontSize = fontSize; ;
        style.normal.textColor = Color.white;
        style.alignment = TextAnchor.MiddleCenter;

        CheckEnv();
    }

    private void OnGUI()
    {
        if (complete) return;
        if (args != null)
        {
            str = "正在解压资源......" + args.progress * 100 + "%\n<color=#00E9FFFF>" + Api.GetFormatFileSize(args.cur) + "/" + Api.GetFormatFileSize(args.total) + "</color>";
            if (args.isDone)
            {
                act();
                File.Delete(zipPath);
                args = null;
            }
        }
        GUI.Label(new Rect(Screen.width / 2f - labelWidth / 2f, Screen.height - labelHeight, labelWidth, labelHeight), str, style);
    }

    private void CheckEnv()
    {
#if DEBUG_MODE
        act.Invoke();
#else
        if (Api.FirstRun)
        {
            StartCoroutine(UnpackAssets());
        }
        else
        {
            act.Invoke();
        }
#endif
    }

    private IEnumerator UnpackAssets()
    {
        Directory.Delete(Application.persistentDataPath, true);
        string path = "";
        if (Application.platform == RuntimePlatform.Android)
            path = Config.StreamingAssetsPath + "/data.zip";
        else
            path = "file://" + Config.StreamingAssetsPath + "/data.zip";
        using (var www = new WWW(path))
        {
            while (!www.isDone)
            {
                yield return null;
                str = "正在读取数据..." + www.progress * 100 + "%";
            }

            if (www.error != null)
            {
                Debug.LogError(www.error);
                yield break;
            }

            zipPath = Application.persistentDataPath + "/data.zip";

            if (File.Exists(zipPath)) File.Delete(zipPath);

            File.WriteAllBytes(zipPath, www.bytes);

            str = "正在解压资源...0%";

            args = ZipUtil.UnpackFileAsync(Application.persistentDataPath, zipPath);
        }
    }
}
