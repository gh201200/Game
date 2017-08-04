using UnityEngine;
using System.Collections;
using System.IO;
using SLua;

public class Init : MonoBehaviour
{
    private LuaSvr svr;

    private void Start()
    {
        LuaState.loaderDelegate += Load;
        svr = new LuaSvr();
        svr.init(p => print("LuaSvr Init -> " + p + "%"), () => svr.start("Main"));
    }

    private byte[] Load(string fn)
    {
        string fullPath = Config.LuaPath + fn;
#if DEBUG_MODE
        if (!fullPath.EndsWith(".lua")) fullPath += ".lua";
#else
        if (!fullPath.EndsWith(".bytes")) fullPath += ".bytes";
#endif
        if (!File.Exists(fullPath))
        {
            Debug.LogError(fullPath + " is not found!");
            return null;
        }
        return File.ReadAllBytes(fullPath);
    }
}
