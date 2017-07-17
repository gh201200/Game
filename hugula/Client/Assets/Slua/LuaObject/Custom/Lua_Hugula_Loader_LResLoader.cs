using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Hugula_Loader_LResLoader : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int LoadLuaTable(IntPtr l) {
		try {
			Hugula.Loader.LResLoader self=(Hugula.Loader.LResLoader)checkSelf(l);
			SLua.LuaTable a1;
			checkType(l,2,out a1);
			System.Action<System.Object> a2;
			LuaDelegation.checkDelegate(l,3,out a2);
			System.Action<Hugula.Loader.LoadingEventArg> a3;
			LuaDelegation.checkDelegate(l,4,out a3);
			self.LoadLuaTable(a1,a2,a3);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int RemoveAllEvents(IntPtr l) {
		try {
			Hugula.Loader.LResLoader self=(Hugula.Loader.LResLoader)checkSelf(l);
			self.RemoveAllEvents();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_onAllCompleteFn(IntPtr l) {
		try {
			Hugula.Loader.LResLoader self=(Hugula.Loader.LResLoader)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onAllCompleteFn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_onAllCompleteFn(IntPtr l) {
		try {
			Hugula.Loader.LResLoader self=(Hugula.Loader.LResLoader)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.onAllCompleteFn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_onProgressFn(IntPtr l) {
		try {
			Hugula.Loader.LResLoader self=(Hugula.Loader.LResLoader)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onProgressFn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_onProgressFn(IntPtr l) {
		try {
			Hugula.Loader.LResLoader self=(Hugula.Loader.LResLoader)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.onProgressFn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_onSharedCompleteFn(IntPtr l) {
		try {
			Hugula.Loader.LResLoader self=(Hugula.Loader.LResLoader)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onSharedCompleteFn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_onSharedCompleteFn(IntPtr l) {
		try {
			Hugula.Loader.LResLoader self=(Hugula.Loader.LResLoader)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.onSharedCompleteFn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_onCacheFn(IntPtr l) {
		try {
			Hugula.Loader.LResLoader self=(Hugula.Loader.LResLoader)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onCacheFn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_onCacheFn(IntPtr l) {
		try {
			Hugula.Loader.LResLoader self=(Hugula.Loader.LResLoader)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.onCacheFn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_onSharedErrFn(IntPtr l) {
		try {
			Hugula.Loader.LResLoader self=(Hugula.Loader.LResLoader)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onSharedErrFn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_onSharedErrFn(IntPtr l) {
		try {
			Hugula.Loader.LResLoader self=(Hugula.Loader.LResLoader)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.onSharedErrFn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_onAssetBundleCompleteFn(IntPtr l) {
		try {
			Hugula.Loader.LResLoader self=(Hugula.Loader.LResLoader)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onAssetBundleCompleteFn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_onAssetBundleCompleteFn(IntPtr l) {
		try {
			Hugula.Loader.LResLoader self=(Hugula.Loader.LResLoader)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.onAssetBundleCompleteFn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_onAssetBundleErrFn(IntPtr l) {
		try {
			Hugula.Loader.LResLoader self=(Hugula.Loader.LResLoader)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onAssetBundleErrFn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_onAssetBundleErrFn(IntPtr l) {
		try {
			Hugula.Loader.LResLoader self=(Hugula.Loader.LResLoader)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.onAssetBundleErrFn=v;
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
			pushValue(l,Hugula.Loader.LResLoader.instance);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Hugula.Loader.LResLoader");
		addMember(l,LoadLuaTable);
		addMember(l,RemoveAllEvents);
		addMember(l,"onAllCompleteFn",get_onAllCompleteFn,set_onAllCompleteFn,true);
		addMember(l,"onProgressFn",get_onProgressFn,set_onProgressFn,true);
		addMember(l,"onSharedCompleteFn",get_onSharedCompleteFn,set_onSharedCompleteFn,true);
		addMember(l,"onCacheFn",get_onCacheFn,set_onCacheFn,true);
		addMember(l,"onSharedErrFn",get_onSharedErrFn,set_onSharedErrFn,true);
		addMember(l,"onAssetBundleCompleteFn",get_onAssetBundleCompleteFn,set_onAssetBundleCompleteFn,true);
		addMember(l,"onAssetBundleErrFn",get_onAssetBundleErrFn,set_onAssetBundleErrFn,true);
		addMember(l,"instance",get_instance,null,false);
		createTypeMetatable(l,null, typeof(Hugula.Loader.LResLoader),typeof(Hugula.Loader.CResLoader));
	}
}
