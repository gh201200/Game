using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Hugula_Utils_LightHelper : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int SetLightMapSetting_s(IntPtr l) {
		try {
			System.UInt16 a1;
			checkType(l,1,out a1);
			UnityEngine.Texture2D a2;
			checkType(l,2,out a2);
			UnityEngine.Texture2D a3;
			checkType(l,3,out a3);
			Hugula.Utils.LightHelper.SetLightMapSetting(a1,a2,a3);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Hugula.Utils.LightHelper");
		addMember(l,SetLightMapSetting_s);
		createTypeMetatable(l,null, typeof(Hugula.Utils.LightHelper));
	}
}
