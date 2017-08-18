using System;
using UnityEngine;
using System.Collections;
using System.IO;
using System.Text;
using SLua;

[CustomLuaClass]
public class LuaManager : MonoBehaviour
{
    private static LuaManager _instance;

    public static LuaManager Instance
    {
        get
        {
            if (_instance == null)
            {
                _instance = Root.Instance.gameObject.AddComponent<LuaManager>();
                LuaState.loaderDelegate += _instance.Load;
                _instance.ready = false;
            }
            return _instance;
        }
    }

    private bool ready = false;

    public LuaSvr luaSvr;
    public LuaState luaState;

    public static Action OnUpdateEvent;
    public static Action OnFixedUpdateEvent;
    public static Action OnLateUpdateEvent;

    public object DoFile(string fileName)
    {
        if (!ready)
        {
            Debug.LogError("LuaState is not init complete yet!");
            return null;
        }
        return luaState.doFile(fileName);
    }

    public object DoString(string LuaCode)
    {
        if (!ready)
        {
            Debug.LogError("LuaState is not init complete yet!");
            return null;
        }
        return luaState.doString(LuaCode);
    }

    public object DoBuffer(byte[] buffer, string fileName)
    {
        if (!ready)
        {
            Debug.LogError("LuaState is not init complete yet!");
            return null;
        }
        object obj = null;
        luaState.doBuffer(buffer, fileName, out obj);
        return obj;
    }

    public LuaFunction GetLuaFunction(string name)
    {
        if (!ready)
        {
            Debug.LogError("LuaState is not init complete yet!");
            return null;
        }
        return luaState[name] as LuaFunction;
    }

    public object CallLuaFunction(string name, params object[] args)
    {
        if (!ready)
        {
            Debug.LogError("LuaState is not init complete yet!");
            return null;
        }
        LuaFunction fun = luaState[name] as LuaFunction;
        if (fun != null)
        {
            return fun.call(args);
        }
        Debug.LogError("function name:" + name + " is not found!");
        return null;
    }

    public object this[string key]
    {
        get { return luaState[key]; }
        set { luaState[key] = value; }
    }

    public void Init(Action<int> progress, Action<LuaManager> complete)
    {
        luaSvr = new LuaSvr();
        luaSvr.init(progress, () =>
        {
            ready = true;
            luaState = luaSvr.luaState;
            if (complete != null) complete(this);
        });
    }

    private byte[] Load(string fn)
    {
        fn = fn.Replace(".lua", "").Replace('.', '/');
        fn += ".lua";
        string fullPath = Config.LuaPath + fn;
        if (!File.Exists(fullPath))
        {
            Debug.LogError(fullPath + " is not found!");
            return null;
        }
        if (!File.Exists(fullPath))
        {
            Debug.LogError(fullPath + " is not found!");
            return null;
        }
        byte[] buffer = File.ReadAllBytes(fullPath);
#if DEBUG_MODE
        return buffer;
#else
        buffer = EncryptUtil.DecryptBytes(buffer, "19930822");
        return buffer;
#endif
    }

    private void Update()
    {
        if (!ready) return;
        if (OnUpdateEvent != null) OnUpdateEvent();
    }

    private void FixedUpdate()
    {
        if (!ready) return;
        if (OnFixedUpdateEvent != null) OnFixedUpdateEvent();
    }

    private void LateUpdate()
    {
        if (!ready) return;
        if (OnLateUpdateEvent != null) OnLateUpdateEvent();
    }
}
