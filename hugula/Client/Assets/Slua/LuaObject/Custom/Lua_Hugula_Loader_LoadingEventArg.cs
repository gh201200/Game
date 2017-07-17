using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Hugula_Loader_LoadingEventArg : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int constructor(IntPtr l) {
		try {
			Hugula.Loader.LoadingEventArg o;
			o=new Hugula.Loader.LoadingEventArg();
			pushValue(l,true);
			pushValue(l,o);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_target(IntPtr l) {
		try {
			Hugula.Loader.LoadingEventArg self=(Hugula.Loader.LoadingEventArg)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.target);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_target(IntPtr l) {
		try {
			Hugula.Loader.LoadingEventArg self=(Hugula.Loader.LoadingEventArg)checkSelf(l);
			System.Object v;
			checkType(l,2,out v);
			self.target=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_total(IntPtr l) {
		try {
			Hugula.Loader.LoadingEventArg self=(Hugula.Loader.LoadingEventArg)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.total);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_total(IntPtr l) {
		try {
			Hugula.Loader.LoadingEventArg self=(Hugula.Loader.LoadingEventArg)checkSelf(l);
			System.Int32 v;
			checkType(l,2,out v);
			self.total=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_current(IntPtr l) {
		try {
			Hugula.Loader.LoadingEventArg self=(Hugula.Loader.LoadingEventArg)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.current);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_current(IntPtr l) {
		try {
			Hugula.Loader.LoadingEventArg self=(Hugula.Loader.LoadingEventArg)checkSelf(l);
			System.Int32 v;
			checkType(l,2,out v);
			self.current=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_progress(IntPtr l) {
		try {
			Hugula.Loader.LoadingEventArg self=(Hugula.Loader.LoadingEventArg)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.progress);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_progress(IntPtr l) {
		try {
			Hugula.Loader.LoadingEventArg self=(Hugula.Loader.LoadingEventArg)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.progress=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Hugula.Loader.LoadingEventArg");
		addMember(l,"target",get_target,set_target,true);
		addMember(l,"total",get_total,set_total,true);
		addMember(l,"current",get_current,set_current,true);
		addMember(l,"progress",get_progress,set_progress,true);
		createTypeMetatable(l,constructor, typeof(Hugula.Loader.LoadingEventArg));
	}
}
