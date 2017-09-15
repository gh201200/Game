using UnityEngine;
using System.Collections;

[System.Serializable]
public class Node
{
    public bool IsWall;

    public Vector3 Pos;

    public int X;

    public int Y;

    public int G;

    public int H;

    public int F { get { return G + H; } }

    public Node Parent;

    public Node(bool isWall, Vector3 pos, int x, int y)
    {
        this.IsWall = isWall;
        this.Pos = pos;
        this.X = x;
        this.Y = y;
    }
}
