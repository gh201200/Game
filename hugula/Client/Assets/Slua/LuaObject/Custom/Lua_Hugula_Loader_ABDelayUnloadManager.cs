using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Hugula_Loader_ABDelayUnloadManager : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_delaySecondTime(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Loader.ABDelayUnloadManager.delaySecondTime);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_delaySecondTime(IntPtr l) {
		try {
			System.Single v;
			checkType(l,2,out v);
			Hugula.Loader.ABDelayUnloadManager.delaySecondTime=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Hugula.Loader.ABDelayUnloadManager");
		addMember(l,"delaySecondTime",get_delaySecondTime,set_delaySecondTime,false);
		createTypeMetatable(l,null, typeof(Hugula.Loader.ABDelayUnloadManager));
	}
}
