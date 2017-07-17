using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Hugula_Pool_PrefabPool : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Clear_s(IntPtr l) {
		try {
			Hugula.Pool.PrefabPool.Clear();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Add_s(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==3){
				System.String a1;
				checkType(l,1,out a1);
				UnityEngine.GameObject a2;
				checkType(l,2,out a2);
				System.Byte a3;
				checkType(l,3,out a3);
				var ret=Hugula.Pool.PrefabPool.Add(a1,a2,a3);
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
			}
			else if(argc==4){
				System.String a1;
				checkType(l,1,out a1);
				UnityEngine.GameObject a2;
				checkType(l,2,out a2);
				System.Byte a3;
				checkType(l,3,out a3);
				System.Boolean a4;
				checkType(l,4,out a4);
				var ret=Hugula.Pool.PrefabPool.Add(a1,a2,a3,a4);
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
			}
			pushValue(l,false);
			LuaDLL.lua_pushstring(l,"No matched override function to call");
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Get_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			var ret=Hugula.Pool.PrefabPool.Get(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int ContainsKey_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			var ret=Hugula.Pool.PrefabPool.ContainsKey(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int GetCache_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			var ret=Hugula.Pool.PrefabPool.GetCache(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int StoreCache_s(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(matchType(l,argc,1,typeof(UnityEngine.GameObject))){
				UnityEngine.GameObject a1;
				checkType(l,1,out a1);
				var ret=Hugula.Pool.PrefabPool.StoreCache(a1);
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
			}
			else if(matchType(l,argc,1,typeof(Hugula.ReferGameObjects))){
				Hugula.ReferGameObjects a1;
				checkType(l,1,out a1);
				var ret=Hugula.Pool.PrefabPool.StoreCache(a1);
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
			}
			pushValue(l,false);
			LuaDLL.lua_pushstring(l,"No matched override function to call");
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Remove_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			Hugula.Pool.PrefabPool.Remove(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int ClearAllCache_s(IntPtr l) {
		try {
			Hugula.Pool.PrefabPool.ClearAllCache();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int ClearCache_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			var ret=Hugula.Pool.PrefabPool.ClearCache(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int ClearCacheImmediate_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			var ret=Hugula.Pool.PrefabPool.ClearCacheImmediate(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int GCCollect_s(IntPtr l) {
		try {
			System.Byte a1;
			checkType(l,1,out a1);
			var ret=Hugula.Pool.PrefabPool.GCCollect(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_deltaTime30(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Pool.PrefabPool.deltaTime30);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_deltaTime25(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Pool.PrefabPool.deltaTime25);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_deltaTime20(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Pool.PrefabPool.deltaTime20);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_deltaTime15(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Pool.PrefabPool.deltaTime15);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_gcDeltaTimeConfig(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Pool.PrefabPool.gcDeltaTimeConfig);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_gcDeltaTimeConfig(IntPtr l) {
		try {
			System.Single v;
			checkType(l,2,out v);
			Hugula.Pool.PrefabPool.gcDeltaTimeConfig=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_threshold1(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Pool.PrefabPool.threshold1);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_threshold1(IntPtr l) {
		try {
			System.Single v;
			checkType(l,2,out v);
			Hugula.Pool.PrefabPool.threshold1=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_threshold2(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Pool.PrefabPool.threshold2);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_threshold2(IntPtr l) {
		try {
			System.Single v;
			checkType(l,2,out v);
			Hugula.Pool.PrefabPool.threshold2=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_threshold3(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Pool.PrefabPool.threshold3);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_threshold3(IntPtr l) {
		try {
			System.Single v;
			checkType(l,2,out v);
			Hugula.Pool.PrefabPool.threshold3=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_instance(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Pool.PrefabPool.instance);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Hugula.Pool.PrefabPool");
		addMember(l,Clear_s);
		addMember(l,Add_s);
		addMember(l,Get_s);
		addMember(l,ContainsKey_s);
		addMember(l,GetCache_s);
		addMember(l,StoreCache_s);
		addMember(l,Remove_s);
		addMember(l,ClearAllCache_s);
		addMember(l,ClearCache_s);
		addMember(l,ClearCacheImmediate_s);
		addMember(l,GCCollect_s);
		addMember(l,"deltaTime30",get_deltaTime30,null,false);
		addMember(l,"deltaTime25",get_deltaTime25,null,false);
		addMember(l,"deltaTime20",get_deltaTime20,null,false);
		addMember(l,"deltaTime15",get_deltaTime15,null,false);
		addMember(l,"gcDeltaTimeConfig",get_gcDeltaTimeConfig,set_gcDeltaTimeConfig,false);
		addMember(l,"threshold1",get_threshold1,set_threshold1,false);
		addMember(l,"threshold2",get_threshold2,set_threshold2,false);
		addMember(l,"threshold3",get_threshold3,set_threshold3,false);
		addMember(l,"instance",get_instance,null,false);
		createTypeMetatable(l,null, typeof(Hugula.Pool.PrefabPool),typeof(UnityEngine.MonoBehaviour));
	}
}
