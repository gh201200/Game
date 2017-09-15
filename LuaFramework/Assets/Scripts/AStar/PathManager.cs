using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using MiniJSON;
#if DEBUG_MODE && UNITY_EDITOR
using UnityEditor;
#endif

[ExecuteInEditMode]
public class PathManager : MonoBehaviour
{
    private static PathManager _instance;

    public static PathManager Instance
    {
        get
        {
            if (_instance == null)
            {
                _instance = new GameObject("Map").AddComponent<PathManager>();
                _instance.pathList = new Dictionary<string, List<Node>>();
                _instance.curPath = new List<Node>();
            }
            return _instance;
        }
    }

    public GameObject cube;
    public List<Node> curPath;

    public GameObject startPos;
    public GameObject endPos;

    [Header("编辑模式")]
    public bool editMode = false;

    //[Header("启用测试寻路")]
    //public bool enableFindPathTest = false;

    [Header("是否缓存已搜索过的路径")]
    public bool cachePath = true;

    [Header("运行时显示网格")]
    public bool showGridRuntime = true;

    [Header("显示底层网格")]
    public bool showGreenGrid = true;

    [Header("显示已缓存的网格")]
    public bool showGreyGrid = true;

    [Header("显示当前路径")]
    public bool showYellowGrid = true;

    [Header("搜索误差格子数")]
    public int gridThreshold = 30;

    [Header("当前误差格子数")]
    public int curThreshold = 0;

    [Header("障碍物层")]
    public LayerMask obstacleLayer;

    [Header("格子尺寸")]
    public float gridSize = 1f;

    [Header("横向格子数量")]
    public int xCount = 50;

    [Header("纵向格子数量")]
    public int yCount = 90;

    private Vector3 reachPos;

    private Node[,] grid;
    private Hashtable objList;
    private Dictionary<string, List<Node>> pathList;

    private void Update()
    {
        if (!Application.isPlaying && editMode)
        {
            Refresh();
            InfoRecord();
        }
    }

    private void Refresh()
    {
        _instance = this;
        grid = new Node[xCount, yCount];
        if (pathList == null) pathList = new Dictionary<string, List<Node>>();
        for (int x = 0; x < xCount; x++)
        {
            for (int y = 0; y < yCount; y++)
            {
                Vector3 pos = new Vector3(transform.position.x + x * gridSize, 0f, transform.position.z + y * gridSize);
                var size = gridSize * 0.5f;
                var isWall = Physics.CheckBox(pos, new Vector3(size, size, size), Quaternion.identity, obstacleLayer);
                grid[x, y] = new Node(isWall, pos, x, y);
            }
        }
        //if (enableFindPathTest && startPos != null && endPos != null) curPath = FindPath(startPos.transform.position, endPos.transform.position);
    }

    /// <summary>
    /// 获取一个网格节点
    /// </summary>
    /// <param name="pos"></param>
    /// <returns></returns>
    public Node GetNode(Vector3 pos)
    {
        var array = ConvertPos(pos);
        return GetNode(array[0], array[1]);
    }

    /// <summary>
    /// 获取一个网格节点
    /// </summary>
    /// <param name="pos"></param>
    /// <returns></returns>
    public Node GetNode(int x, int y)
    {
        if (IsOutRange(x, y))
        {
            Debug.LogError(string.Format("grid[{0}, {1}] 已越界", x, y));
            return null;
        }
        return grid[x, y];
    }

    /// <summary>
    /// 获取附近的节点
    /// </summary>
    /// <param name="pos"></param>
    /// <returns></returns>
    public List<Node> GetNearNode(Vector3 pos)
    {
        if (IsOutRange(pos)) return new List<Node>();
        var node = GetNode(pos);
        return GetNearNode(node);
    }

    /// <summary>
    /// 获取附近的节点
    /// </summary>
    /// <param name="pos"></param>
    /// <returns></returns>
    public List<Node> GetNearNode(int x, int y)
    {
        if (IsOutRange(x, y)) return new List<Node>();
        var node = GetNode(x, y);
        return GetNearNode(node);
    }

    /// <summary>
    /// 获取附近的节点
    /// </summary>
    /// <param name="pos"></param>
    /// <returns></returns>
    public List<Node> GetNearNode(Node node)
    {
        List<Node> list = new List<Node>();
        for (int i = -1; i <= 1; i++)
        {
            for (int j = -1; j <= 1; j++)
            {
                if (i == 0 && j == 0) continue;
                var x = node.X + i;
                var y = node.Y + j;
                if (!IsOutRange(x, y))
                {
                    var nearNode = GetNode(x, y);
                    list.Add(nearNode);
                }
            }
        }
        return list;
    }

    /// <summary>
    /// 寻路
    /// </summary>
    /// <param name="pos1"></param>
    /// <param name="pos2"></param>
    /// <returns></returns>
    public List<Node> FindPath(Vector3 pos1, Vector3 pos2)
    {
        var start = GetNode(pos1);
        var end = GetNode(pos2);
        if (start == null || end == null) return new List<Node>();
        return FindPath(start, end);
    }

    /// <summary>
    /// 寻路
    /// </summary>
    /// <param name="pos1"></param>
    /// <param name="pos2"></param>
    /// <returns></returns>
    public List<Node> FindPath(Node start, Node end)
    {
        if (cachePath && pathList != null)
        {
            HashSet<List<Node>> path = new HashSet<List<Node>>();
            foreach (var cur in pathList.Values)
            {
                var node = cur[cur.Count - 1];
                if (node.X == end.X && node.Y == end.Y)
                {
                    //path.Add(cur);
                    var newPath = new List<Node>();
                    var index = 0;
                    for (int i = 0; i < cur.Count; i++)
                    {
                        if (CanWalkLine(start.Pos, cur[i].Pos)) index = i;
                        else break;
                    }
                    for (int i = index; i < cur.Count; i++)
                    {
                        newPath.Add(cur[i]);
                    }
                    if (newPath.Count > 0) path.Add(newPath);
                }
            }

            if (path.Count > 0)
            {
                List<Node> curPath = null;
                var curDis = -1f;
                foreach (var cur in path)
                {
                    var startNode = cur[0];
                    reachPos = GetReachablePos(start.Pos, end.Pos);
                    var dis = Vector3.Distance(reachPos, startNode.Pos);
                    curThreshold = Mathf.FloorToInt(dis / gridSize);
                    if (curThreshold > gridThreshold) continue;
                    if (curDis < 0)
                    {
                        curPath = cur;
                        curDis = dis;
                    }
                    else
                    {
                        if (dis < curDis)
                        {
                            curPath = cur;
                            curDis = dis;
                        }
                    }
                }
                if (curPath != null)
                {
                    curPath.Insert(0, start);
                    return curPath;
                }
            }
        }

        var searchNodeEnd = end;
        List<Node> open = new List<Node>();
        List<Node> close = new List<Node>();
        open.Add((Node)start);

        while (open.Count > 0 && !searchNodeEnd.IsWall && !start.IsWall)
        {
            var curNode = open[0];
            for (int i = 0; i < open.Count; i++)
            {
                var node = open[i];
                if (node.F <= curNode.F && node.H < curNode.H)
                {
                    curNode = node;
                }
            }
            open.Remove(curNode);
            close.Add(curNode);

            if (curNode == searchNodeEnd)
            {
                return GeneratePath(start, searchNodeEnd);
            }

            var nearNodes = GetNearNode(curNode);

            for (int i = 0; i < nearNodes.Count; i++)
            {
                var node = nearNodes[i];
                if (node.IsWall || close.Contains(node)) continue;
                var newCost = curNode.G + GetDistance(curNode, node);
                if (!open.Contains(node) || newCost < node.G)
                {
                    node.G = newCost;
                    node.H = GetDistance(node, searchNodeEnd);
                    node.Parent = curNode;
                    if (!open.Contains(node)) open.Add(node);
                }
            }
        }
        searchNodeEnd = GetNode(GetReachablePos(start.Pos, searchNodeEnd.Pos));
        if (start.IsWall) return new List<Node>();
        return FindPath(start, searchNodeEnd);
    }

    /// <summary>
    /// 如果无法从起点到达终点 寻找一个终点附近的点
    /// </summary>
    /// <param name="pos1"></param>
    /// <param name="pos2"></param>
    /// <returns></returns>
    public Vector3 GetReachablePos(Vector3 pos1, Vector3 pos2)
    {
        var dir = pos2 - pos1;
        var pointCount = Mathf.RoundToInt(dir.magnitude / gridSize);
        if (pointCount <= 0)
        {
            return grid[0, 0].Pos;
        }
        List<Vector3> posList = new List<Vector3>();
        for (int i = 1; i <= pointCount; i++)
        {
            var pos = pos1 + dir.normalized * (gridSize * i);
            if (IsOutRange(pos)) break;
            if (GetNode(pos).IsWall) break;
            posList.Add(pos);
        }
        if (posList.Count == 0) return grid[0, 0].Pos;
        posList = posList.OrderByDescending(v => (v - pos1).magnitude).ToList();

        var target = posList[0];
        var list = GetNearNode(target);
        if (list.Count > 0)
        {
            var curNode = list[0];
            Node preNode = null;
            while (true)
            {
                preNode = curNode;
                var node1 = CreateNode(false, pos1);
                var node2 = CreateNode(false, pos2);
                var curDis = GetDistance(node1, curNode) + GetDistance(curNode, node2);
                foreach (var node in list)
                {
                    var dis = GetDistance(node1, node) + GetDistance(node, node2);
                    if (dis < curDis && !node.IsWall)
                    {
                        curDis = dis;
                        curNode = node;
                        target = curNode.Pos;
                    }
                }
                if (preNode == curNode) break;
                list = GetNearNode(curNode);
            }
        }
        return target;
    }

    /// <summary>
    /// 是否超出地图范围
    /// </summary>
    /// <param name="x"></param>
    /// <param name="y"></param>
    /// <returns></returns>
    public bool IsOutRange(int x, int y)
    {
        if (x >= xCount || x < 0 || y >= yCount || y < 0) return true;
        return false;
    }

    /// <summary>
    /// 是否超出地图范围
    /// </summary>
    /// <param name="x"></param>
    /// <param name="y"></param>
    /// <returns></returns>
    public bool IsOutRange(Vector3 pos)
    {
        var array = ConvertPos(pos);
        return IsOutRange(array[0], array[1]);
    }

    /// <summary>
    /// 转换世界坐标为网格xy
    /// </summary>
    /// <param name="pos"></param>
    /// <returns></returns>
    public int[] ConvertPos(Vector3 pos)
    {
        var x = Mathf.RoundToInt((pos.x - transform.position.x) / gridSize);
        var y = Mathf.RoundToInt((pos.z - transform.position.z) / gridSize);
        var array = new[] { x, y };
        return array;
    }

    /// <summary>
    /// 是否是障碍物
    /// </summary>
    /// <param name="pos"></param>
    /// <returns></returns>
    public bool IsWall(Vector3 pos)
    {
        if (IsOutRange(pos)) return false;
        return !GetNode(pos).IsWall;
    }

    /// <summary>
    /// 是否是障碍物
    /// </summary>
    /// <param name="pos"></param>
    /// <returns></returns>
    public bool IsWall(int x, int y)
    {
        if (IsOutRange(x, y)) return false;
        return !GetNode(x, y).IsWall;
    }

    /// <summary>
    /// 是否可以直线到达
    /// </summary>
    /// <param name="pos1"></param>
    /// <param name="pos2"></param>
    /// <returns></returns>
    public bool CanWalkLine(Vector3 pos1, Vector3 pos2)
    {
        var dir = pos2 - pos1;
        var pointCount = Mathf.RoundToInt(dir.magnitude / gridSize);
        if (pointCount <= 0)
        {
            return false;
        };
        for (int i = 1; i <= pointCount; i++)
        {
            var pos = pos1 + dir.normalized * (gridSize * i);
            if (IsOutRange(pos) || GetNode(pos).IsWall) return false;
        }
        return true;
    }

    /// <summary>
    /// 两点直线上的节点
    /// </summary>
    /// <param name="pos1"></param>
    /// <param name="pos2"></param>
    /// <returns></returns>
    public List<Node> GetNodes(Vector3 pos1, Vector3 pos2)
    {
        var dir = pos2 - pos1;
        var pointCount = Mathf.RoundToInt(dir.magnitude / gridSize);
        if (pointCount <= 0)
        {
            return new List<Node>();
        }
        List<Node> posList = new List<Node>();
        for (int i = 1; i <= pointCount; i++)
        {
            var pos = pos1 + dir.normalized * (gridSize * i);
            if (IsOutRange(pos)) break;
            if (GetNode(pos).IsWall) break;
            var node = GetNode(pos);
            posList.Add(node);
        }
        return posList;
    }

    public Node[,] GetGridList()
    {
        return grid;
    }

    public Hashtable GetObjList()
    {
        return objList;
    }

    public void Clear()
    {
        if (objList != null)
        {
            foreach (DictionaryEntry o in objList)
            {
                var item = o.Value as Hashtable;
                foreach (DictionaryEntry de in item)
                {
                    var go = de.Key as GameObject;
                    if (go != null) DestroyImmediate(go);
                }
            }
        }
        grid = null;
        pathList = null;
        curPath = null;
        objList = null;
        transform.position = Vector3.zero;
    }

    /// <summary>
    /// 初始化地图
    /// </summary>
    /// <param name="gridConfig">网格Json配置</param>
    /// <param name="objConfig">游戏物体Json配置</param>
    public void InitMap(string gridConfig, string objConfig)
    {
        InitGrid(gridConfig);
        InitObj(objConfig);
    }

    private void InitGrid(string gridConfig)
    {
        Dictionary<string, object> dic = Json.Deserialize(gridConfig) as Dictionary<string, object>;
        Dictionary<string, object> desDic = dic["des"] as Dictionary<string, object>;
        Dictionary<string, object> gridDic = dic["grids"] as Dictionary<string, object>;
        if (desDic == null || gridDic == null)
        {
            Debug.LogError("init grid failed!");
            return;
        }
        gridSize = float.Parse(desDic["gridSize"].ToString());
        xCount = int.Parse(desDic["xCount"].ToString());
        yCount = int.Parse(desDic["yCount"].ToString());
        gridThreshold = int.Parse(desDic["gridThreshold"].ToString());
        obstacleLayer = int.Parse(desDic["obstacleLayer"].ToString());

        grid = new Node[xCount, yCount];

        foreach (Dictionary<string, object> v in gridDic.Values)
        {
            var x = int.Parse(v["X"].ToString());
            var y = int.Parse(v["Y"].ToString());
            var isWall = bool.Parse(v["IsWall"].ToString());
            var posStr = v["position"].ToString();
            var posArray = posStr.Split(',');
            var pos = new Vector3(float.Parse(posArray[0]), float.Parse(posArray[1]), float.Parse(posArray[2]));
            grid[x, y] = new Node(isWall, pos, x, y);
        }
    }

    private void InitObj(string objConfig)
    {
        Dictionary<string, object> dic = Json.Deserialize(objConfig) as Dictionary<string, object>;
        foreach (var p in dic)
        {
            var path = p.Key;
            var objs = p.Value as List<object>;
            foreach (Dictionary<string, object> d in objs)
            {
                var posStr = d["position"].ToString();
                var posArray = posStr.Split(',');
                var pos = new Vector3(float.Parse(posArray[0]), float.Parse(posArray[1]), float.Parse(posArray[2]));

                var eulerStr = d["eulerAngles"].ToString();
                var eulerArray = eulerStr.Split(',');
                var eulerAngles = new Vector3(float.Parse(eulerArray[0]), float.Parse(eulerArray[1]), float.Parse(eulerArray[2]));

                var scaleStr = d["scale"].ToString();
                var scaleArray = scaleStr.Split(',');
                var scale = new Vector3(float.Parse(scaleArray[0]), float.Parse(scaleArray[1]), float.Parse(scaleArray[2]));

                AssetLoader.Instance.LoadAsync(path, AssetType.Prefab, o =>
                {
                    var go = Instantiate(o as UnityEngine.Object) as GameObject;
                    go.transform.SetParent(transform);
                    go.transform.localPosition = pos;
                    go.transform.localEulerAngles = eulerAngles;
                    go.transform.localScale = scale;
                });
            }
        }
    }

    /// <summary>
    /// 生成路径并保存
    /// </summary>
    /// <param name="startNode"></param>
    /// <param name="endNode"></param>
    /// <returns></returns>
    private List<Node> GeneratePath(Node startNode, Node endNode)
    {
        List<Node> path = new List<Node>();
        if (endNode != null)
        {
            Node temp = endNode;
            while (temp != startNode)
            {
                path.Add(temp);
                temp = temp.Parent;
            }
            path.Reverse();
            if (cachePath && pathList != null)
            {
                var key = GetPathKey(startNode.X, startNode.Y, endNode.X, endNode.Y);
                if (!pathList.ContainsKey(key))
                {
                    pathList.Add(key, path);
                }
            }
        }
        return path;
    }

    private Node CreateNode(bool isWall, Vector3 pos)
    {
        var array = ConvertPos(pos);
        return new Node(isWall, pos, array[0], array[1]);
    }

    private int GetDistance(Node a, Node b)
    {
        int cntX = Mathf.Abs(a.X - b.X);
        int cntY = Mathf.Abs(a.Y - b.Y);
        if (cntX > cntY)
        {
            return 14 * cntY + 10 * (cntX - cntY);
        }
        else
        {
            return 14 * cntX + 10 * (cntY - cntX);
        }
    }

    private string GetPathKey(int x1, int y1, int x2, int y2)
    {
        return x1 + "-" + y1 + "-" + x2 + "-" + y2;
    }

    private void OnDrawGizmos()
    {
        if (!showGridRuntime && Application.isPlaying) return;

        if (showGreenGrid)
        {
            //绘制底层网格
            if (grid == null || grid.Length < xCount * yCount) return;
            for (int x = 0; x < xCount; x++)
            {
                for (int y = 0; y < yCount; y++)
                {
                    var node = grid[x, y];
                    if (node.IsWall) Gizmos.color = Color.red;
                    else Gizmos.color = Color.green;
                    Gizmos.DrawWireCube(node.Pos, new Vector3(gridSize, 0f, gridSize));
                }
            }
        }

        if (showGreyGrid && pathList != null)
        {
            //绘制已缓存的路径
            foreach (var p in pathList.Values)
            {
                for (int j = 0; j < p.Count; j++)
                {
                    var node = p[j];
                    Gizmos.color = Color.grey;
                    Gizmos.DrawWireCube(node.Pos, new Vector3(gridSize, 0f, gridSize));
                }
            }
        }

        if (showYellowGrid && curPath != null)
        {
            //绘制当前路径
            for (int i = 0; i < curPath.Count; i++)
            {
                var node = curPath[i];
                Gizmos.color = Color.yellow;
                Gizmos.DrawWireCube(node.Pos, new Vector3(gridSize, 0f, gridSize));
            }

            if (startPos && endPos)
            {
                Debug.DrawLine(startPos.transform.position, reachPos, Color.cyan);
            }
        }
    }

    private void InfoRecord()
    {
#if DEBUG_MODE && UNITY_EDITOR
        if (objList == null) objList = new Hashtable();
        GameObject[] gos = Selection.gameObjects; ;
        GameObject[] array = new GameObject[transform.childCount];
        for (int i = 0; i < transform.childCount; i++)
        {
            array[i] = transform.GetChild(i).gameObject;
        }
        List<GameObject> list = new List<GameObject>();
        list.AddRange(gos);
        list.AddRange(array);
        foreach (var go in list)
        {
            if (go != null && go.tag.EndsWith(".prefab"))
            {
                if (!go.tag.StartsWith("Res/"))
                {
                    Debug.LogError("标签设置错误！name:" + go.name + " tag:" + go.tag);
                    return;
                }
                if (go.transform.parent == null) go.transform.SetParent(transform);
                var path = go.tag.Replace("Res/", "");
                Hashtable info = null;
                if (objList.ContainsKey(path))
                {
                    info = objList[path] as Hashtable;
                }
                else
                {
                    info = new Hashtable();
                    objList.Add(path, info);
                }
                if (info == null)
                {
                    Debug.LogError("unknow exception!");
                    return;
                }
                Hashtable item = null;
                if (info.ContainsKey(go))
                {
                    item = info[go] as Hashtable;
                }
                else
                {
                    item = new Hashtable();
                    info[go] = item;
                }
                if (item == null)
                {
                    Debug.LogError("unknow exception!");
                    return;
                }
                item["position"] = go.transform.localPosition;
                item["eulerAngles"] = go.transform.localEulerAngles;
                item["scale"] = go.transform.localScale;
            }
        }
#endif
    }
}
