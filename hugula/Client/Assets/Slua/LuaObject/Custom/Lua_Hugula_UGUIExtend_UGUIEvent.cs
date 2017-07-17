using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Hugula_UGUIExtend_UGUIEvent : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int onCustomerHandle_s(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(matchType(l,argc,1,typeof(System.Object),typeof(UnityEngine.Vector3))){
				System.Object a1;
				checkType(l,1,out a1);
				UnityEngine.Vector3 a2;
				checkType(l,2,out a2);
				Hugula.UGUIExtend.UGUIEvent.onCustomerHandle(a1,a2);
				pushValue(l,true);
				return 1;
			}
			else if(matchType(l,argc,1,typeof(System.Object),typeof(System.Object))){
				System.Object a1;
				checkType(l,1,out a1);
				System.Object a2;
				checkType(l,2,out a2);
				Hugula.UGUIExtend.UGUIEvent.onCustomerHandle(a1,a2);
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
	static public int onPressHandle_s(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(matchType(l,argc,1,typeof(UnityEngine.Object),typeof(bool))){
				UnityEngine.Object a1;
				checkType(l,1,out a1);
				System.Boolean a2;
				checkType(l,2,out a2);
				Hugula.UGUIExtend.UGUIEvent.onPressHandle(a1,a2);
				pushValue(l,true);
				return 1;
			}
			else if(matchType(l,argc,1,typeof(UnityEngine.Object),typeof(System.Object))){
				UnityEngine.Object a1;
				checkType(l,1,out a1);
				System.Object a2;
				checkType(l,2,out a2);
				Hugula.UGUIExtend.UGUIEvent.onPressHandle(a1,a2);
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
	static public int onClickHandle_s(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(matchType(l,argc,1,typeof(UnityEngine.Object),typeof(UnityEngine.Vector3))){
				UnityEngine.Object a1;
				checkType(l,1,out a1);
				UnityEngine.Vector3 a2;
				checkType(l,2,out a2);
				Hugula.UGUIExtend.UGUIEvent.onClickHandle(a1,a2);
				pushValue(l,true);
				return 1;
			}
			else if(matchType(l,argc,1,typeof(UnityEngine.Object),typeof(System.Object))){
				UnityEngine.Object a1;
				checkType(l,1,out a1);
				System.Object a2;
				checkType(l,2,out a2);
				Hugula.UGUIExtend.UGUIEvent.onClickHandle(a1,a2);
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
	static public int onDragHandle_s(IntPtr l) {
		try {
			UnityEngine.Object a1;
			checkType(l,1,out a1);
			UnityEngine.Vector3 a2;
			checkType(l,2,out a2);
			Hugula.UGUIExtend.UGUIEvent.onDragHandle(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int onDropHandle_s(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(matchType(l,argc,1,typeof(UnityEngine.Object),typeof(UnityEngine.Vector3))){
				UnityEngine.Object a1;
				checkType(l,1,out a1);
				UnityEngine.Vector3 a2;
				checkType(l,2,out a2);
				Hugula.UGUIExtend.UGUIEvent.onDropHandle(a1,a2);
				pushValue(l,true);
				return 1;
			}
			else if(matchType(l,argc,1,typeof(UnityEngine.Object),typeof(bool))){
				UnityEngine.Object a1;
				checkType(l,1,out a1);
				System.Boolean a2;
				checkType(l,2,out a2);
				Hugula.UGUIExtend.UGUIEvent.onDropHandle(a1,a2);
				pushValue(l,true);
				return 1;
			}
			else if(matchType(l,argc,1,typeof(UnityEngine.Object),typeof(System.Object))){
				UnityEngine.Object a1;
				checkType(l,1,out a1);
				System.Object a2;
				checkType(l,2,out a2);
				Hugula.UGUIExtend.UGUIEvent.onDropHandle(a1,a2);
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
	static public int onSelectHandle_s(IntPtr l) {
		try {
			UnityEngine.Object a1;
			checkType(l,1,out a1);
			System.Object a2;
			checkType(l,2,out a2);
			Hugula.UGUIExtend.UGUIEvent.onSelectHandle(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int onCancelHandle_s(IntPtr l) {
		try {
			UnityEngine.Object a1;
			checkType(l,1,out a1);
			System.Object a2;
			checkType(l,2,out a2);
			Hugula.UGUIExtend.UGUIEvent.onCancelHandle(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int RemoveAllEvents_s(IntPtr l) {
		try {
			Hugula.UGUIExtend.UGUIEvent.RemoveAllEvents();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_onCustomerFn(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.UGUIExtend.UGUIEvent.onCustomerFn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_onCustomerFn(IntPtr l) {
		try {
			SLua.LuaFunction v;
			checkType(l,2,out v);
			Hugula.UGUIExtend.UGUIEvent.onCustomerFn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_onPressFn(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.UGUIExtend.UGUIEvent.onPressFn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_onPressFn(IntPtr l) {
		try {
			SLua.LuaFunction v;
			checkType(l,2,out v);
			Hugula.UGUIExtend.UGUIEvent.onPressFn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_onClickFn(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.UGUIExtend.UGUIEvent.onClickFn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_onClickFn(IntPtr l) {
		try {
			SLua.LuaFunction v;
			checkType(l,2,out v);
			Hugula.UGUIExtend.UGUIEvent.onClickFn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_onDragFn(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.UGUIExtend.UGUIEvent.onDragFn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_onDragFn(IntPtr l) {
		try {
			SLua.LuaFunction v;
			checkType(l,2,out v);
			Hugula.UGUIExtend.UGUIEvent.onDragFn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_onDropFn(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.UGUIExtend.UGUIEvent.onDropFn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_onDropFn(IntPtr l) {
		try {
			SLua.LuaFunction v;
			checkType(l,2,out v);
			Hugula.UGUIExtend.UGUIEvent.onDropFn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_onSelectFn(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.UGUIExtend.UGUIEvent.onSelectFn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_onSelectFn(IntPtr l) {
		try {
			SLua.LuaFunction v;
			checkType(l,2,out v);
			Hugula.UGUIExtend.UGUIEvent.onSelectFn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_onCancelFn(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.UGUIExtend.UGUIEvent.onCancelFn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_onCancelFn(IntPtr l) {
		try {
			SLua.LuaFunction v;
			checkType(l,2,out v);
			Hugula.UGUIExtend.UGUIEvent.onCancelFn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Hugula.UGUIExtend.UGUIEvent");
		addMember(l,onCustomerHandle_s);
		addMember(l,onPressHandle_s);
		addMember(l,onClickHandle_s);
		addMember(l,onDragHandle_s);
		addMember(l,onDropHandle_s);
		addMember(l,onSelectHandle_s);
		addMember(l,onCancelHandle_s);
		addMember(l,RemoveAllEvents_s);
		addMember(l,"onCustomerFn",get_onCustomerFn,set_onCustomerFn,false);
		addMember(l,"onPressFn",get_onPressFn,set_onPressFn,false);
		addMember(l,"onClickFn",get_onClickFn,set_onClickFn,false);
		addMember(l,"onDragFn",get_onDragFn,set_onDragFn,false);
		addMember(l,"onDropFn",get_onDropFn,set_onDropFn,false);
		addMember(l,"onSelectFn",get_onSelectFn,set_onSelectFn,false);
		addMember(l,"onCancelFn",get_onCancelFn,set_onCancelFn,false);
		createTypeMetatable(l,null, typeof(Hugula.UGUIExtend.UGUIEvent));
	}
}
