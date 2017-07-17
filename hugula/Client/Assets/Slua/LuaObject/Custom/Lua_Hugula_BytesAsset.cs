using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Hugula_BytesAsset : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int constructor(IntPtr l) {
		try {
			Hugula.BytesAsset o;
			o=new Hugula.BytesAsset();
			pushValue(l,true);
			pushValue(l,o);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_bytes(IntPtr l) {
		try {
			Hugula.BytesAsset self=(Hugula.BytesAsset)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.bytes);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_bytes(IntPtr l) {
		try {
			Hugula.BytesAsset self=(Hugula.BytesAsset)checkSelf(l);
			System.Byte[] v;
			checkArray(l,2,out v);
			self.bytes=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Hugula.BytesAsset");
		addMember(l,"bytes",get_bytes,set_bytes,true);
		createTypeMetatable(l,constructor, typeof(Hugula.BytesAsset),typeof(UnityEngine.ScriptableObject));
	}
}
