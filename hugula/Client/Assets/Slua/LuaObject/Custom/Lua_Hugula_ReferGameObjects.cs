using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Hugula_ReferGameObjects : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Get(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(matchType(l,argc,2,typeof(int))){
				Hugula.ReferGameObjects self=(Hugula.ReferGameObjects)checkSelf(l);
				System.Int32 a1;
				checkType(l,2,out a1);
				var ret=self.Get(a1);
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
			}
			else if(matchType(l,argc,2,typeof(string))){
				Hugula.ReferGameObjects self=(Hugula.ReferGameObjects)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				var ret=self.Get(a1);
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
	static public int get_monos(IntPtr l) {
		try {
			Hugula.ReferGameObjects self=(Hugula.ReferGameObjects)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.monos);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_monos(IntPtr l) {
		try {
			Hugula.ReferGameObjects self=(Hugula.ReferGameObjects)checkSelf(l);
			UnityEngine.Object[] v;
			checkArray(l,2,out v);
			self.monos=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_userObject(IntPtr l) {
		try {
			Hugula.ReferGameObjects self=(Hugula.ReferGameObjects)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.userObject);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_userObject(IntPtr l) {
		try {
			Hugula.ReferGameObjects self=(Hugula.ReferGameObjects)checkSelf(l);
			System.Object v;
			checkType(l,2,out v);
			self.userObject=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_userBool(IntPtr l) {
		try {
			Hugula.ReferGameObjects self=(Hugula.ReferGameObjects)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.userBool);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_userBool(IntPtr l) {
		try {
			Hugula.ReferGameObjects self=(Hugula.ReferGameObjects)checkSelf(l);
			System.Boolean v;
			checkType(l,2,out v);
			self.userBool=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_userInt(IntPtr l) {
		try {
			Hugula.ReferGameObjects self=(Hugula.ReferGameObjects)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.userInt);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_userInt(IntPtr l) {
		try {
			Hugula.ReferGameObjects self=(Hugula.ReferGameObjects)checkSelf(l);
			System.Int32 v;
			checkType(l,2,out v);
			self.userInt=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_Length(IntPtr l) {
		try {
			Hugula.ReferGameObjects self=(Hugula.ReferGameObjects)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.Length);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Hugula.ReferGameObjects");
		addMember(l,Get);
		addMember(l,"monos",get_monos,set_monos,true);
		addMember(l,"userObject",get_userObject,set_userObject,true);
		addMember(l,"userBool",get_userBool,set_userBool,true);
		addMember(l,"userInt",get_userInt,set_userInt,true);
		addMember(l,"Length",get_Length,null,true);
		createTypeMetatable(l,null, typeof(Hugula.ReferGameObjects),typeof(UnityEngine.MonoBehaviour));
	}
}
