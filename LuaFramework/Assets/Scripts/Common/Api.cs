using UnityEngine;
using System.Collections;
using System.Text;

[SLua.CustomLuaClass]
public class Api
{
    public static string GetString(byte[] buffer)
    {
        return Encoding.UTF8.GetString(buffer);
    }

    public static byte[] GetBytes(string str)
    {
        return Encoding.UTF8.GetBytes(str);
    }
}
