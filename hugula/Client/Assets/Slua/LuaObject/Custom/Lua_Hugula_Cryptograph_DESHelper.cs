using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Hugula_Cryptograph_DESHelper : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_KEYData(IntPtr l) {
		try {
			Hugula.Cryptograph.DESHelper self=(Hugula.Cryptograph.DESHelper)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.KEYData);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_KEYData(IntPtr l) {
		try {
			Hugula.Cryptograph.DESHelper self=(Hugula.Cryptograph.DESHelper)checkSelf(l);
			Hugula.Cryptograph.KeyVData v;
			checkType(l,2,out v);
			self.KEYData=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_IVData(IntPtr l) {
		try {
			Hugula.Cryptograph.DESHelper self=(Hugula.Cryptograph.DESHelper)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.IVData);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_IVData(IntPtr l) {
		try {
			Hugula.Cryptograph.DESHelper self=(Hugula.Cryptograph.DESHelper)checkSelf(l);
			Hugula.Cryptograph.KeyVData v;
			checkType(l,2,out v);
			self.IVData=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_Key(IntPtr l) {
		try {
			Hugula.Cryptograph.DESHelper self=(Hugula.Cryptograph.DESHelper)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.Key);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_IV(IntPtr l) {
		try {
			Hugula.Cryptograph.DESHelper self=(Hugula.Cryptograph.DESHelper)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.IV);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_instance(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Cryptograph.DESHelper.instance);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Hugula.Cryptograph.DESHelper");
		addMember(l,"KEYData",get_KEYData,set_KEYData,true);
		addMember(l,"IVData",get_IVData,set_IVData,true);
		addMember(l,"Key",get_Key,null,true);
		addMember(l,"IV",get_IV,null,true);
		addMember(l,"instance",get_instance,null,false);
		createTypeMetatable(l,null, typeof(Hugula.Cryptograph.DESHelper),typeof(UnityEngine.MonoBehaviour));
	}
}
