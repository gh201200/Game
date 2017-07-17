using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Hugula_UGUIExtend_CEventReceive : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int OnPointerDown(IntPtr l) {
		try {
			Hugula.UGUIExtend.CEventReceive self=(Hugula.UGUIExtend.CEventReceive)checkSelf(l);
			UnityEngine.EventSystems.BaseEventData a1;
			checkType(l,2,out a1);
			self.OnPointerDown(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int OnPointerUp(IntPtr l) {
		try {
			Hugula.UGUIExtend.CEventReceive self=(Hugula.UGUIExtend.CEventReceive)checkSelf(l);
			UnityEngine.EventSystems.BaseEventData a1;
			checkType(l,2,out a1);
			self.OnPointerUp(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int OnDrag(IntPtr l) {
		try {
			Hugula.UGUIExtend.CEventReceive self=(Hugula.UGUIExtend.CEventReceive)checkSelf(l);
			UnityEngine.EventSystems.BaseEventData a1;
			checkType(l,2,out a1);
			self.OnDrag(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int OnDrop(IntPtr l) {
		try {
			Hugula.UGUIExtend.CEventReceive self=(Hugula.UGUIExtend.CEventReceive)checkSelf(l);
			UnityEngine.EventSystems.BaseEventData a1;
			checkType(l,2,out a1);
			self.OnDrop(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int OnPointerClick(IntPtr l) {
		try {
			Hugula.UGUIExtend.CEventReceive self=(Hugula.UGUIExtend.CEventReceive)checkSelf(l);
			UnityEngine.EventSystems.BaseEventData a1;
			checkType(l,2,out a1);
			self.OnPointerClick(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int OnSelect(IntPtr l) {
		try {
			Hugula.UGUIExtend.CEventReceive self=(Hugula.UGUIExtend.CEventReceive)checkSelf(l);
			UnityEngine.EventSystems.BaseEventData a1;
			checkType(l,2,out a1);
			self.OnSelect(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int OnCancel(IntPtr l) {
		try {
			Hugula.UGUIExtend.CEventReceive self=(Hugula.UGUIExtend.CEventReceive)checkSelf(l);
			UnityEngine.EventSystems.BaseEventData a1;
			checkType(l,2,out a1);
			self.OnCancel(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int OnButtonClick(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(matchType(l,argc,2,typeof(UnityEngine.Object))){
				Hugula.UGUIExtend.CEventReceive self=(Hugula.UGUIExtend.CEventReceive)checkSelf(l);
				UnityEngine.Object a1;
				checkType(l,2,out a1);
				self.OnButtonClick(a1);
				pushValue(l,true);
				return 1;
			}
			else if(matchType(l,argc,2,typeof(UnityEngine.MonoBehaviour))){
				Hugula.UGUIExtend.CEventReceive self=(Hugula.UGUIExtend.CEventReceive)checkSelf(l);
				UnityEngine.MonoBehaviour a1;
				checkType(l,2,out a1);
				self.OnButtonClick(a1);
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
	static public int OnCustomerEvent(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(matchType(l,argc,2,typeof(UnityEngine.Object))){
				Hugula.UGUIExtend.CEventReceive self=(Hugula.UGUIExtend.CEventReceive)checkSelf(l);
				UnityEngine.Object a1;
				checkType(l,2,out a1);
				self.OnCustomerEvent(a1);
				pushValue(l,true);
				return 1;
			}
			else if(matchType(l,argc,2,typeof(UnityEngine.MonoBehaviour))){
				Hugula.UGUIExtend.CEventReceive self=(Hugula.UGUIExtend.CEventReceive)checkSelf(l);
				UnityEngine.MonoBehaviour a1;
				checkType(l,2,out a1);
				self.OnCustomerEvent(a1);
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
	static public void reg(IntPtr l) {
		getTypeTable(l,"Hugula.UGUIExtend.CEventReceive");
		addMember(l,OnPointerDown);
		addMember(l,OnPointerUp);
		addMember(l,OnDrag);
		addMember(l,OnDrop);
		addMember(l,OnPointerClick);
		addMember(l,OnSelect);
		addMember(l,OnCancel);
		addMember(l,OnButtonClick);
		addMember(l,OnCustomerEvent);
		createTypeMetatable(l,null, typeof(Hugula.UGUIExtend.CEventReceive),typeof(UnityEngine.MonoBehaviour));
	}
}
