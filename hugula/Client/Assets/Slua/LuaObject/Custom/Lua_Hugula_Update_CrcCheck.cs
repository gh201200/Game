using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Hugula_Update_CrcCheck : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int ContainsKey_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			var ret=Hugula.Update.CrcCheck.ContainsKey(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int GetCrc_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			var ret=Hugula.Update.CrcCheck.GetCrc(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int CheckCrc_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.UInt32 a2;
			checkType(l,2,out a2);
			var ret=Hugula.Update.CrcCheck.CheckCrc(a1,a2);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int CheckUriCrc_s(IntPtr l) {
		try {
			Hugula.Loader.CRequest a1;
			checkType(l,1,out a1);
			var ret=Hugula.Update.CrcCheck.CheckUriCrc(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int CheckLocalFileCrc_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.UInt32 a2;
			var ret=Hugula.Update.CrcCheck.CheckLocalFileCrc(a1,out a2);
			pushValue(l,true);
			pushValue(l,ret);
			pushValue(l,a2);
			return 3;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int CheckLocalFileWeakCrc_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.UInt32 a2;
			var ret=Hugula.Update.CrcCheck.CheckLocalFileWeakCrc(a1,out a2);
			pushValue(l,true);
			pushValue(l,ret);
			pushValue(l,a2);
			return 3;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int GetLocalFileCrc_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.UInt32 a2;
			var ret=Hugula.Update.CrcCheck.GetLocalFileCrc(a1,out a2);
			pushValue(l,true);
			pushValue(l,ret);
			pushValue(l,a2);
			return 3;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Add_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.UInt32 a2;
			checkType(l,2,out a2);
			Hugula.Update.CrcCheck.Add(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Remove_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			var ret=Hugula.Update.CrcCheck.Remove(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Clear_s(IntPtr l) {
		try {
			Hugula.Update.CrcCheck.Clear();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_beginCheck(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Update.CrcCheck.beginCheck);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_beginCheck(IntPtr l) {
		try {
			System.Boolean v;
			checkType(l,2,out v);
			Hugula.Update.CrcCheck.beginCheck=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Hugula.Update.CrcCheck");
		addMember(l,ContainsKey_s);
		addMember(l,GetCrc_s);
		addMember(l,CheckCrc_s);
		addMember(l,CheckUriCrc_s);
		addMember(l,CheckLocalFileCrc_s);
		addMember(l,CheckLocalFileWeakCrc_s);
		addMember(l,GetLocalFileCrc_s);
		addMember(l,Add_s);
		addMember(l,Remove_s);
		addMember(l,Clear_s);
		addMember(l,"beginCheck",get_beginCheck,set_beginCheck,false);
		createTypeMetatable(l,null, typeof(Hugula.Update.CrcCheck));
	}
}
