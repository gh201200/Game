using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using SLua;
using UnityEngine.UI;
using System.Linq;

public enum LayoutType
{
    Vertical,
    Horizontal
}

public class UIScroller : MonoBehaviour
{
    public int count = 0;
    public LayoutType layoutType = LayoutType.Vertical;
    public ScrollRect sr;
    public RectTransform viewPort;
    public RectTransform content;
    public GameObject prefab;
    public float cellWidth = 500f;
    public float cellHeight = 100f;
    public float cellSpacing = 15f;

    private Dictionary<int, Hashtable> data;
    private int index = 0;

    private Vector2 viewPortPos;

    private void Awake()
    {
        //viewPortPos = viewPort.position;
        data = new Dictionary<int, Hashtable>();
        InitRectTransform(viewPort);
        InitRectTransform(content);
        sr.onValueChanged.AddListener(OnValueChange);
        //viewPort.position = viewPortPos;
    }

    private void OnValueChange(Vector2 pos)
    {
        foreach (var t in data.Values)
        {
            var go = t["go"] as GameObject;
            var label = go.transform.Find("Text").GetComponent<Text>();
            var pos1 = viewPort.InverseTransformPoint(go.transform.position);
            label.text = pos1 + " index:" + GetIndex(pos1);
        }
    }

    public int Add(GameObject go, object info)
    {
        go.name = index.ToString();
        go.transform.SetParent(content);
        go.transform.localScale = Vector3.one;
        var rt = go.GetComponent<RectTransform>();
        InitRectTransform(rt);
        rt.sizeDelta = new Vector2(cellWidth, cellHeight);
        var table = new Hashtable();
        table.Add("index", index);
        table.Add("go", go);
        table.Add("info", info);
        data.Add(index, table);
        Refresh();
        return index++;
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
        go.name = index.ToString();
        go.transform.SetParent(content);
        go.transform.localScale = Vector3.one;
        var rt = go.GetComponent<RectTransform>();
        InitRectTransform(rt);
        rt.sizeDelta = new Vector2(cellWidth, cellHeight);
        var table = new Hashtable();
        table.Add("index", index);
        table.Add("go", go);
        table.Add("info", info);
        data.Add(index, table);
        Refresh();
    }

    public void Delete(int index)
    {
        if (!data.ContainsKey(index))
        {
            Debug.LogError("the key you want to remove is not exists! index:" + index);
            return;
        }
        var table = data[index];
        var go = table["go"] as GameObject;
        Destroy(go);
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

    private void Refresh()
    {
        data = data.OrderBy(o => o.Key).ToDictionary(o => o.Key, o => o.Value);
        content.sizeDelta = GetContentSize();
        int num = 0;
        foreach (var p in data)
        {
            var go = p.Value["go"] as GameObject;
            if (go == null)
            {
                Debug.LogError("go is null");
                return;
            }
            go.transform.localPosition = GetPos(num);
            num++;
        }
        count = data.Count;
    }

    private Vector2 GetContentSize()
    {
        Vector2 size = Vector2.zero;
        switch (layoutType)
        {
            case LayoutType.Vertical:
                size = new Vector2(cellWidth, data.Count * cellHeight + (data.Count - 1) * cellSpacing);
                break;
            case LayoutType.Horizontal:
                size = new Vector2(data.Count * cellWidth + (data.Count - 1) * cellSpacing, cellHeight);
                break;
        }
        return size;
    }

    private Vector2 GetPos(int index)
    {
        Vector2 pos = Vector2.zero;
        var offset = 0f;
        switch (layoutType)
        {
            case LayoutType.Vertical:
                offset = index * (cellHeight + cellSpacing);
                pos = new Vector2(0, -offset);
                break;
            case LayoutType.Horizontal:
                offset = index * (cellWidth + cellSpacing);
                pos = new Vector2(offset, 0);
                break;
        }
        return pos;
    }

    private int GetIndex(Vector2 pos)
    {
        int res = 0;
        var offset = 0f;
        switch (layoutType)
        {
            case LayoutType.Vertical:
                offset = -pos.y;
                res = Mathf.CeilToInt(offset / (cellHeight + cellSpacing));
                break;
            case LayoutType.Horizontal:
                offset = pos.x;
                res = Mathf.CeilToInt(offset / (cellWidth + cellSpacing));
                break;
        }
        return res;
    }

    private void InitRectTransform(RectTransform rt)
    {
        switch (layoutType)
        {
            case LayoutType.Vertical:
                rt.pivot = new Vector2(0.5f, 1f);
                rt.anchorMax = new Vector2(0.5f, 1f);
                rt.anchorMin = new Vector2(0.5f, 1f);
                break;
            case LayoutType.Horizontal:
                rt.pivot = new Vector2(0f, 0.5f);
                rt.anchorMax = new Vector2(0f, 0.5f);
                rt.anchorMin = new Vector2(0f, 0.5f);
                break;
        }
    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.Q))
        {
            var go = Instantiate(prefab);
            go.transform.localScale = Vector3.one;
            go.transform.localEulerAngles = Vector3.zero;
            var res = Add(go, null);
            go.transform.Find("Text").GetComponent<Text>().text = "index:" + res;
        }
        if (Input.GetKeyDown(KeyCode.W))
        {
            DeleteFirst();
        }
    }
}
