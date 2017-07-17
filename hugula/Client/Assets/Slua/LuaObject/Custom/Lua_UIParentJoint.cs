using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_UIParentJoint : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int AddChild(IntPtr l) {
		try {
			UIParentJoint self=(UIParentJoint)checkSelf(l);
			UnityEngine.Transform a1;
			checkType(l,2,out a1);
			System.Int32 a2;
			checkType(l,3,out a2);
			self.AddChild(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_index(IntPtr l) {
		try {
			UIParentJoint self=(UIParentJoint)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.index);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_index(IntPtr l) {
		try {
			UIParentJoint self=(UIParentJoint)checkSelf(l);
			System.Int32 v;
			checkType(l,2,out v);
			self.index=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"UIParentJoint");
		addMember(l,AddChild);
		addMember(l,"index",get_index,set_index,true);
		createTypeMetatable(l,null, typeof(UIParentJoint),typeof(UnityEngine.MonoBehaviour));
	}
}
