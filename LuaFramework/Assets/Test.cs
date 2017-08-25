using UnityEngine;
using System.Diagnostics;
using Debug = UnityEngine.Debug;

public class Test : MonoBehaviour
{
    void Start()
    {
        Stopwatch sw = new Stopwatch();
        sw.Start();
        AssetLoader.Instance.LoadAsync("prefabs/giftpanel.prefab", AssetType.Prefab, obj =>
        {
            GameObject go = Instantiate((UnityEngine.Object)obj) as GameObject;
            go.transform.SetParent(this.transform);
            go.transform.localPosition = Vector3.zero;
            go.transform.localScale = Vector3.one;
            go.transform.localEulerAngles = Vector3.zero;
            RectTransform rt = go.GetComponent<RectTransform>();
            rt.anchorMin = Vector3.zero;
            rt.anchorMax = Vector3.one;
            rt.offsetMin = Vector3.zero;
            rt.offsetMax = Vector3.zero;
            Debug.Log("load AssetBundle: " + sw.ElapsedMilliseconds + "ms");
        });

        Stopwatch sw2 = new Stopwatch();
        sw2.Start();
        AssetLoader.Instance.LoadAsync("prefabs/tip.prefab", AssetType.Prefab, obj =>
        {
            GameObject go = Instantiate((UnityEngine.Object)obj) as GameObject;
            go.transform.SetParent(this.transform);
            go.transform.localPosition = Vector3.zero;
            go.transform.localScale = Vector3.one;
            go.transform.localEulerAngles = Vector3.zero;
            //RectTransform rt = go.GetComponent<RectTransform>();
            //rt.anchorMin = Vector3.zero;
            //rt.anchorMax = Vector3.one;
            //rt.offsetMin = Vector3.zero;
            //rt.offsetMax = Vector3.zero;
            Debug.Log("load AssetBundle: " + sw2.ElapsedMilliseconds + "ms");
        });

        Stopwatch sw3 = new Stopwatch();
        sw3.Start();
        AssetLoader.Instance.LoadAsync("prefabs/test.prefab", AssetType.Prefab, obj =>
        {
            GameObject go = Instantiate((UnityEngine.Object)obj) as GameObject;
            go.transform.SetParent(this.transform);
            go.transform.localPosition = Vector3.zero;
            go.transform.localScale = Vector3.one;
            go.transform.localEulerAngles = Vector3.zero;
            //RectTransform rt = go.GetComponent<RectTransform>();
            //rt.anchorMin = Vector3.zero;
            //rt.anchorMax = Vector3.one;
            //rt.offsetMin = Vector3.zero;
            //rt.offsetMax = Vector3.zero;
            Debug.Log("load AssetBundle: " + sw3.ElapsedMilliseconds + "ms");
        });

        //Queue<int> que = new Queue<int>();
        //for (int i = 0; i < 10; i++)
        //{
        //    que.Enqueue(i);
        //}
        //foreach (int i in que)
        //{
        //    Debug.Log(i);
        //}
    }

    void Update()
    {
        //if (Input.GetKeyDown(KeyCode.E)) TimeManager.Instance.DeleteAll();
        //if (Input.GetKeyDown(KeyCode.Q))
        //{
        //    TimeManager.Instance.Add(1000, () => print("test delay 1000"));
        //    TimeManager.Instance.AddCycle(500, 100, () => print("test cycle delay 100 -> " + DateTime.Now.ToString("yyyy-MM-dd hh:mm:ss fff")));
        //    TimeManager.Instance.AddCycle(0, 200, () => print("frame count -> " + Time.time / Time.frameCount));
        //}
    }
}
