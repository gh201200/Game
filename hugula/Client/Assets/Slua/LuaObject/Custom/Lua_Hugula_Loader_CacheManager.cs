using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Hugula_Loader_CacheManager : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int ClearDelay_s(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(matchType(l,argc,1,typeof(int))){
				System.Int32 a1;
				checkType(l,1,out a1);
				Hugula.Loader.CacheManager.ClearDelay(a1);
				pushValue(l,true);
				return 1;
			}
			else if(matchType(l,argc,1,typeof(string))){
				System.String a1;
				checkType(l,1,out a1);
				Hugula.Loader.CacheManager.ClearDelay(a1);
				pushValue(l,true);
				return 1;
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
	static public int UnloadCacheFalse_s(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(matchType(l,argc,1,typeof(int))){
				System.Int32 a1;
				checkType(l,1,out a1);
				var ret=Hugula.Loader.CacheManager.UnloadCacheFalse(a1);
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
			}
			else if(matchType(l,argc,1,typeof(string))){
				System.String a1;
				checkType(l,1,out a1);
				var ret=Hugula.Loader.CacheManager.UnloadCacheFalse(a1);
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
	static public int UnloadDependenciesCacheFalse_s(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(matchType(l,argc,1,typeof(int))){
				System.Int32 a1;
				checkType(l,1,out a1);
				var ret=Hugula.Loader.CacheManager.UnloadDependenciesCacheFalse(a1);
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
			}
			else if(matchType(l,argc,1,typeof(string))){
				System.String a1;
				checkType(l,1,out a1);
				var ret=Hugula.Loader.CacheManager.UnloadDependenciesCacheFalse(a1);
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
	static public int Unload_s(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(matchType(l,argc,1,typeof(int))){
				System.Int32 a1;
				checkType(l,1,out a1);
				var ret=Hugula.Loader.CacheManager.Unload(a1);
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
			}
			else if(matchType(l,argc,1,typeof(string))){
				System.String a1;
				checkType(l,1,out a1);
				var ret=Hugula.Loader.CacheManager.Unload(a1);
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
	static public int Contains_s(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(matchType(l,argc,1,typeof(string))){
				System.String a1;
				checkType(l,1,out a1);
				var ret=Hugula.Loader.CacheManager.Contains(a1);
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
			}
			else if(matchType(l,argc,1,typeof(int))){
				System.Int32 a1;
				checkType(l,1,out a1);
				var ret=Hugula.Loader.CacheManager.Contains(a1);
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
	static public int ClearAll_s(IntPtr l) {
		try {
			Hugula.Loader.CacheManager.ClearAll();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_Typeof_String(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Loader.CacheManager.Typeof_String);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_Typeof_Bytes(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Loader.CacheManager.Typeof_Bytes);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_Typeof_AssetBundle(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Loader.CacheManager.Typeof_AssetBundle);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_Typeof_ABScene(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Loader.CacheManager.Typeof_ABScene);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_Typeof_ABAllAssets(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Loader.CacheManager.Typeof_ABAllAssets);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_Typeof_AudioClip(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Loader.CacheManager.Typeof_AudioClip);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_Typeof_Texture2D(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Loader.CacheManager.Typeof_Texture2D);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_Typeof_Object(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Loader.CacheManager.Typeof_Object);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Hugula.Loader.CacheManager");
		addMember(l,ClearDelay_s);
		addMember(l,UnloadCacheFalse_s);
		addMember(l,UnloadDependenciesCacheFalse_s);
		addMember(l,Unload_s);
		addMember(l,Contains_s);
		addMember(l,ClearAll_s);
		addMember(l,"Typeof_String",get_Typeof_String,null,false);
		addMember(l,"Typeof_Bytes",get_Typeof_Bytes,null,false);
		addMember(l,"Typeof_AssetBundle",get_Typeof_AssetBundle,null,false);
		addMember(l,"Typeof_ABScene",get_Typeof_ABScene,null,false);
		addMember(l,"Typeof_ABAllAssets",get_Typeof_ABAllAssets,null,false);
		addMember(l,"Typeof_AudioClip",get_Typeof_AudioClip,null,false);
		addMember(l,"Typeof_Texture2D",get_Typeof_Texture2D,null,false);
		addMember(l,"Typeof_Object",get_Typeof_Object,null,false);
		createTypeMetatable(l,null, typeof(Hugula.Loader.CacheManager));
	}
}
