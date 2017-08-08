using UnityEngine;
using System.Collections;
using System.IO;
using SLua;

public class Init : MonoBehaviour
{
    private void Start()
    {
        LuaManager.Instance.Init(p => Debug.Log("lua init -> " + p + "%"), instance =>
        {
            //instance.DoString(@"
            //                     print('hello world!')
            //");
            instance.DoFile("Main");
        });
    }
}
