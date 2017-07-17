using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Hugula_Loader_CountMananger : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Subtract_s(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(matchType(l,argc,1,typeof(string))){
				System.String a1;
				checkType(l,1,out a1);
				var ret=Hugula.Loader.CountMananger.Subtract(a1);
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
			}
			else if(matchType(l,argc,1,typeof(int))){
				System.Int32 a1;
				checkType(l,1,out a1);
				var ret=Hugula.Loader.CountMananger.Subtract(a1);
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
	static public int Add_s(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(matchType(l,argc,1,typeof(string))){
				System.String a1;
				checkType(l,1,out a1);
				var ret=Hugula.Loader.CountMananger.Add(a1);
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
			}
			else if(matchType(l,argc,1,typeof(int))){
				System.Int32 a1;
				checkType(l,1,out a1);
				var ret=Hugula.Loader.CountMananger.Add(a1);
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
	static public int WillAdd_s(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(matchType(l,argc,1,typeof(string))){
				System.String a1;
				checkType(l,1,out a1);
				var ret=Hugula.Loader.CountMananger.WillAdd(a1);
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
			}
			else if(matchType(l,argc,1,typeof(int))){
				System.Int32 a1;
				checkType(l,1,out a1);
				var ret=Hugula.Loader.CountMananger.WillAdd(a1);
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
	static public void reg(IntPtr l) {
		getTypeTable(l,"Hugula.Loader.CountMananger");
		addMember(l,Subtract_s);
		addMember(l,Add_s);
		addMember(l,WillAdd_s);
		createTypeMetatable(l,null, typeof(Hugula.Loader.CountMananger));
	}
}
