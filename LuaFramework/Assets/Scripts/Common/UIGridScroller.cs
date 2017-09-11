using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using SLua;
using UnityEngine.UI;
using System.Linq;

[CustomLuaClass]
[ExecuteInEditMode]
[RequireComponent(typeof(ScrollRect))]
public class UIGridScroller : MonoBehaviour
{
    /// <summary>
    /// 布局类型
    /// </summary>
    public enum LayoutType
    {
        Vertical,
        Horizontal
    }

    /// <summary>
    /// item激活回调
    /// </summary>
    public Action<int, GameObject, object> OnShowEvent;

    /// <summary>
    /// item隐藏回调
    /// </summary>
    public Action<int> OnHideEvent;

    [Header("布局方向")]
    public LayoutType layoutType = LayoutType.Vertical;

    [Header("已插入总数据长度")]
    public int count = 0;

    [Header("滑动过程中每隔多少帧刷新一次")]
    public int refreshInterval = 15;

    [Header("单个元素宽度")]
    public float cellWidth = 500f;

    [Header("单个元素高度")]
    public float cellHeight = 100f;

    [Header("元素间隔")]
    public float cellSpacing = 15f;

    [Header("水平位置偏移")]
    public float xOffset = 0f;

    [Header("垂直位置偏移")]
    public float yOffset = 0f;

    private int xNum = 0;
    private int yNum = 0;
    private float xSize = 0f;
    private float ySize = 0f;

    private int maxShowCount = 0;
    private int startIndex = 0;
    private int hideCount = 0;

    private ScrollRect sr;
    private RectTransform viewPort;
    private RectTransform content;
    private GameObject prefab;

    private Dictionary<int, Hashtable> data;
    private Queue<GameObject> hideQue;
    private int index = 0;
    private int lastRefreshFrameCount = 0;

    private void Awake()
    {
        if (Application.isPlaying)
        {
            Init();
            data = new Dictionary<int, Hashtable>();
            hideQue = new Queue<GameObject>();
            maxShowCount = GetShowCount();
            sr.onValueChanged.AddListener(OnValueChange);
        }
        //OnShowEvent += (num, obj, info) =>
        //{
        //    GameObject go = obj as GameObject;
        //    go.transform.SetSiblingIndex(num);
        //    go.name = info.ToString();
        //    go.transform.Find("Text").GetComponent<Text>().text = go.name;
        //};
    }

    //private IEnumerator Start()
    //{
    //    if (!Application.isPlaying) yield break;
    //    for (int i = 0; i < 500; i++)
    //    {
    //        Add(UnityEditor.AssetDatabase.LoadAssetAtPath<GameObject>("Assets/Res/Prefabs/UI/Common/Item.prefab"), index);
    //        yield return null;
    //    }
    //}

    private void OnValueChange(Vector2 pos)
    {
        if ((Time.frameCount - lastRefreshFrameCount) >= refreshInterval || startIndex != GetIndex())
        {
            Refresh();
            //print("refresh interval: "+(Time.frameCount - lastRefreshFrameCount));
            lastRefreshFrameCount = Time.frameCount;
        }
    }

    public int Add(GameObject go, object info)
    {
        Insert(index, go, info);
        return index;
    }

    public int AddFirst(GameObject go, object info)
    {
        Insert(0, go, info);
        return 0;
    }

    public int AddLast(GameObject go, object info)
    {
        Insert(index, go, info);
        return index;
    }

    public void Insert(int index, GameObject go, object info)
    {
        StartCoroutine(CoInsert(index, go, info));
    }

    public void Delete(int index)
    {
        if (!data.ContainsKey(index))
        {
            Debug.LogError("the key you want to remove is not exists! index:" + index);
            return;
        }

        var table = data[index];
        if (table["go"] != null)
        {
            var go = table["go"] as GameObject;
            Destroy(go);
        }
        data.Remove(index);

        Refresh();
    }

    public void DeleteFirst()
    {
        var deleteIndex = 0;
        while (data.Count > 0 && !data.ContainsKey(deleteIndex))
        {
            deleteIndex++;
        }
        if (data.ContainsKey(deleteIndex)) Delete(deleteIndex);
    }

    public void DeleteLast()
    {
        var deleteIndex = index;
        while (data.Count > 0 && !data.ContainsKey(deleteIndex))
        {
            deleteIndex--;
        }
        if (data.ContainsKey(deleteIndex)) Delete(deleteIndex);
    }

    private IEnumerator CoInsert(int index, GameObject go, object info)
    {
        if (data.ContainsKey(index))
        {
            Dictionary<int, Hashtable> dic = new Dictionary<int, Hashtable>();
            foreach (var p in data)
            {
                if (p.Key >= index) dic.Add(p.Key, p.Value);
            }
            foreach (var p in dic)
            {
                data.Remove(p.Key);
            }
            foreach (var p in dic)
            {
                data.Add(p.Key + 1, p.Value);
            }
        }
        var table = new Hashtable();
        table.Add("id", index);
        table.Add("info", info);
        data.Add(index, table);
        prefab = go;
        this.index++;
        yield return null;
        Refresh();
    }

    private void Refresh()
    {
        CoRefresh();
    }

    private void CoRefresh()
    {
        maxShowCount = GetShowCount();
        content.sizeDelta = GetContentSize();
        count = data.Count;
        data = data.OrderBy(o => o.Key).ToDictionary(o => o.Key, o => o.Value);
        int num = 0;
        foreach (var p in data)
        {
            p.Value["index"] = num;
            num++;
        }
        startIndex = GetIndex();
        hideCount = hideQue.Count;
        //for (int i = startIndex - maxShowCount - hideQue.Count; i < startIndex + maxShowCount * 2; i++)
        for (int i = 0; i < index; i++)
        {
            Hashtable table = null;
            data.TryGetValue(i, out table);
            if (table == null) continue;
            var obj = table["go"];
            var posIndex = (int)table["index"];
            var active = posIndex >= startIndex && posIndex < startIndex + maxShowCount;
            if (active)
            {
                GameObject go = null;
                if (obj != null)
                {
                    go = obj as GameObject;
                }
                else
                {
                    if (hideQue.Count > 0)
                    {
                        go = hideQue.Dequeue();
                    }
                    else
                    {
                        go = Instantiate(prefab);
                        go.transform.SetParent(content);
                        go.transform.localScale = Vector3.one;
                    }
                }
                var rt = go.GetComponent<RectTransform>();
                InitRectTransform(rt);
                rt.sizeDelta = new Vector2(cellWidth, cellHeight);
                go.transform.SetSiblingIndex(i);
                go.SetActive(true);
                go.transform.localPosition = GetPos((int)table["index"]);
                table["go"] = go;
                if (OnShowEvent != null) OnShowEvent((int)table["id"], go, table["info"]);
            }
            else
            {
                if (obj != null)
                {
                    var go = obj as GameObject;
                    hideQue.Enqueue(go as GameObject);
                    go.SetActive(false);
                    table.Remove("go");
                }
                if (OnHideEvent != null) OnHideEvent((int)table["id"]);
            }
        }
    }

    private Vector2 GetContentSize()
    {
        ComputeNum();
        Vector2 size = Vector2.zero;
        if (layoutType == LayoutType.Vertical)
        {
            ySize = yNum * (cellHeight + cellSpacing) - cellSpacing;
            size.x = content.sizeDelta.x;
            size.y = ySize;
        }
        else if (layoutType == LayoutType.Horizontal)
        {
            xSize = xNum * (cellWidth + cellSpacing) - cellSpacing;
            size.x = xSize;
            size.y = content.sizeDelta.y;
        }
        size.x = Mathf.Max(size.x, 10);
        size.y = Mathf.Max(size.y, 10);
        return size;
    }

    private Vector2 GetPos(int index)
    {
        Vector2 pos = Vector2.zero;
        if (layoutType == LayoutType.Vertical)
        {
            var xpos = (index % xNum) * (cellWidth + cellSpacing);
            var ypos = 0f;
            var n = index / xNum;
            if (n != 0) ypos = n * (cellHeight + cellSpacing);
            pos.x = xpos;
            pos.y = -ypos;
        }
        else if (layoutType == LayoutType.Horizontal)
        {
            var ypos = (index % yNum) * (cellHeight + cellSpacing);
            var xpos = 0f;
            var n = index / yNum;
            if (n != 0) xpos = n * (cellWidth + cellSpacing);
            pos.x = xpos;
            pos.y = -ypos;
        }
        pos.x += xOffset;
        pos.y += yOffset;
        return pos;
    }

    private int GetShowCount()
    {
        ComputeNum();
        if (layoutType == LayoutType.Vertical)
        {
            var num = Mathf.CeilToInt((viewPort.sizeDelta.y + cellSpacing) / (cellHeight + cellSpacing));
            return ++num * xNum;
        }
        if (layoutType == LayoutType.Horizontal)
        {
            var num = Mathf.CeilToInt((viewPort.sizeDelta.x + cellSpacing) / (cellWidth + cellSpacing));
            return ++num * yNum;
        }
        return 0;
    }

    private void ComputeNum()
    {
        if (layoutType == LayoutType.Vertical)
        {
            xNum = Mathf.FloorToInt((viewPort.sizeDelta.x + cellSpacing) / (cellWidth + cellSpacing));
            yNum = Mathf.CeilToInt(count / (float)xNum);
            xNum = Mathf.Max(xNum, 1);
            yNum = Mathf.Max(yNum, 1);
        }
        else if (layoutType == LayoutType.Horizontal)
        {
            yNum = Mathf.FloorToInt((viewPort.sizeDelta.y + cellSpacing) / (cellHeight + cellSpacing));
            xNum = Mathf.CeilToInt(count / (float)yNum);
            xNum = Mathf.Max(xNum, 1);
            yNum = Mathf.Max(yNum, 1);
        }
    }

    private int GetIndex()
    {
        int res = 0;
        if (layoutType == LayoutType.Vertical)
        {
            res = Mathf.FloorToInt((content.localPosition.y + cellSpacing) / (cellHeight + cellSpacing)) * xNum;
        }
        else if (layoutType == LayoutType.Horizontal)
        {
            res = Mathf.FloorToInt(-(content.localPosition.x + cellSpacing) / (cellWidth + cellSpacing)) * yNum;
        }
        return res;
    }

    private void InitRectTransform(RectTransform rt)
    {
        rt.pivot = new Vector2(0f, 1f);
        rt.anchorMax = new Vector2(0f, 1f);
        rt.anchorMin = new Vector2(0f, 1f);
    }

    private void Init()
    {
        sr = this.GetComponent<ScrollRect>();

        content = sr.content;
        viewPort = sr.viewport;

        if (content != null) InitRectTransform(content);
        if (viewPort != null) InitRectTransform(viewPort);

        if (content == null || viewPort == null || Application.isPlaying) return;
        if (layoutType == LayoutType.Vertical)
        {
            sr.vertical = true;
            sr.horizontal = false;
        }
        else if (layoutType == LayoutType.Horizontal)
        {
            sr.vertical = false;
            sr.horizontal = true;
        }
        count = content.childCount;
        content.sizeDelta = GetContentSize();
        for (int i = 0; i < content.childCount; i++)
        {
            var rt = content.GetChild(i).GetComponent<RectTransform>();
            InitRectTransform(rt);
            rt.sizeDelta = new Vector2(cellWidth, cellHeight);
            rt.localPosition = GetPos(i);
        }
    }

    private void Update()
    {
        if (!Application.isPlaying)
        {
            Init();
        }
    }
}
