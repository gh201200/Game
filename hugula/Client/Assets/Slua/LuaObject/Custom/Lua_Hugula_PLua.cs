using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Hugula_PLua : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int ReStart(IntPtr l) {
		try {
			Hugula.PLua self=(Hugula.PLua)checkSelf(l);
			System.Single a1;
			checkType(l,2,out a1);
			self.ReStart(a1);
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
			Hugula.PLua self=(Hugula.PLua)checkSelf(l);
			self.RemoveAllEvents();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int PreInitLua_s(IntPtr l) {
		try {
			Hugula.PLua.PreInitLua();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Delay_s(IntPtr l) {
		try {
			SLua.LuaFunction a1;
			checkType(l,1,out a1);
			System.Single a2;
			checkType(l,2,out a2);
			System.Object[] a3;
			checkParams(l,3,out a3);
			var ret=Hugula.PLua.Delay(a1,a2,a3);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int StopDelay_s(IntPtr l) {
		try {
			UnityEngine.Coroutine a1;
			checkType(l,1,out a1);
			Hugula.PLua.StopDelay(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int StopAllDelay_s(IntPtr l) {
		try {
			Hugula.PLua.StopAllDelay();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_enterLua(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.PLua.enterLua);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_enterLua(IntPtr l) {
		try {
			System.String v;
			checkType(l,2,out v);
			Hugula.PLua.enterLua=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_onDestroyFn(IntPtr l) {
		try {
			Hugula.PLua self=(Hugula.PLua)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onDestroyFn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_onDestroyFn(IntPtr l) {
		try {
			Hugula.PLua self=(Hugula.PLua)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.onDestroyFn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_onAppPauseFn(IntPtr l) {
		try {
			Hugula.PLua self=(Hugula.PLua)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onAppPauseFn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_onAppPauseFn(IntPtr l) {
		try {
			Hugula.PLua self=(Hugula.PLua)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.onAppPauseFn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_onAppQuitFn(IntPtr l) {
		try {
			Hugula.PLua self=(Hugula.PLua)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onAppQuitFn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_onAppQuitFn(IntPtr l) {
		try {
			Hugula.PLua self=(Hugula.PLua)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.onAppQuitFn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_onAppFocusFn(IntPtr l) {
		try {
			Hugula.PLua self=(Hugula.PLua)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onAppFocusFn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_onAppFocusFn(IntPtr l) {
		try {
			Hugula.PLua self=(Hugula.PLua)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.onAppFocusFn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_lua(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.PLua.lua);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_lua(IntPtr l) {
		try {
			SLua.LuaSvr v;
			checkType(l,2,out v);
			Hugula.PLua.lua=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_updateFn(IntPtr l) {
		try {
			Hugula.PLua self=(Hugula.PLua)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.updateFn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_updateFn(IntPtr l) {
		try {
			Hugula.PLua self=(Hugula.PLua)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.updateFn=v;
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
			pushValue(l,Hugula.PLua.instance);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Hugula.PLua");
		addMember(l,ReStart);
		addMember(l,RemoveAllEvents);
		addMember(l,PreInitLua_s);
		addMember(l,Delay_s);
		addMember(l,StopDelay_s);
		addMember(l,StopAllDelay_s);
		addMember(l,"enterLua",get_enterLua,set_enterLua,false);
		addMember(l,"onDestroyFn",get_onDestroyFn,set_onDestroyFn,true);
		addMember(l,"onAppPauseFn",get_onAppPauseFn,set_onAppPauseFn,true);
		addMember(l,"onAppQuitFn",get_onAppQuitFn,set_onAppQuitFn,true);
		addMember(l,"onAppFocusFn",get_onAppFocusFn,set_onAppFocusFn,true);
		addMember(l,"lua",get_lua,set_lua,false);
		addMember(l,"updateFn",get_updateFn,set_updateFn,true);
		addMember(l,"instance",get_instance,null,false);
		createTypeMetatable(l,null, typeof(Hugula.PLua),typeof(UnityEngine.MonoBehaviour));
	}
}
