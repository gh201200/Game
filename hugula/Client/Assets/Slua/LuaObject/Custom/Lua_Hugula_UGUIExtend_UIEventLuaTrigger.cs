using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Hugula_UGUIExtend_UIEventLuaTrigger : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int OnLuaTrigger(IntPtr l) {
		try {
			Hugula.UGUIExtend.UIEventLuaTrigger self=(Hugula.UGUIExtend.UIEventLuaTrigger)checkSelf(l);
			self.OnLuaTrigger();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_luaFn(IntPtr l) {
		try {
			Hugula.UGUIExtend.UIEventLuaTrigger self=(Hugula.UGUIExtend.UIEventLuaTrigger)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.luaFn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_luaFn(IntPtr l) {
		try {
			Hugula.UGUIExtend.UIEventLuaTrigger self=(Hugula.UGUIExtend.UIEventLuaTrigger)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.luaFn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_trigger(IntPtr l) {
		try {
			Hugula.UGUIExtend.UIEventLuaTrigger self=(Hugula.UGUIExtend.UIEventLuaTrigger)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.trigger);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_trigger(IntPtr l) {
		try {
			Hugula.UGUIExtend.UIEventLuaTrigger self=(Hugula.UGUIExtend.UIEventLuaTrigger)checkSelf(l);
			UnityEngine.MonoBehaviour v;
			checkType(l,2,out v);
			self.trigger=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_target(IntPtr l) {
		try {
			Hugula.UGUIExtend.UIEventLuaTrigger self=(Hugula.UGUIExtend.UIEventLuaTrigger)checkSelf(l);
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
			Hugula.UGUIExtend.UIEventLuaTrigger self=(Hugula.UGUIExtend.UIEventLuaTrigger)checkSelf(l);
			System.Collections.Generic.List<UnityEngine.MonoBehaviour> v;
			checkType(l,2,out v);
			self.target=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Hugula.UGUIExtend.UIEventLuaTrigger");
		addMember(l,OnLuaTrigger);
		addMember(l,"luaFn",get_luaFn,set_luaFn,true);
		addMember(l,"trigger",get_trigger,set_trigger,true);
		addMember(l,"target",get_target,set_target,true);
		createTypeMetatable(l,null, typeof(Hugula.UGUIExtend.UIEventLuaTrigger),typeof(UnityEngine.MonoBehaviour));
	}
}
