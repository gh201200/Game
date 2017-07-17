using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_AssetBundleScene : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int constructor(IntPtr l) {
		try {
			AssetBundleScene o;
			o=new AssetBundleScene();
			pushValue(l,true);
			pushValue(l,o);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"AssetBundleScene");
		createTypeMetatable(l,constructor, typeof(AssetBundleScene));
	}
}
