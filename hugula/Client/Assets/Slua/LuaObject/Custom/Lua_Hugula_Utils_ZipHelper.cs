using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Hugula_Utils_ZipHelper : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int constructor(IntPtr l) {
		try {
			Hugula.Utils.ZipHelper o;
			o=new Hugula.Utils.ZipHelper();
			pushValue(l,true);
			pushValue(l,o);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int CreateGZip_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.Collections.Generic.List<System.String> a2;
			checkType(l,2,out a2);
			System.String a3;
			checkType(l,3,out a3);
			Hugula.Utils.ZipHelper.CreateGZip(a1,a2,a3);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int ExtractGZip_s(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(matchType(l,argc,1,typeof(System.Array),typeof(string))){
				System.Array a1;
				checkType(l,1,out a1);
				System.String a2;
				checkType(l,2,out a2);
				Hugula.Utils.ZipHelper.ExtractGZip(a1,a2);
				pushValue(l,true);
				return 1;
			}
			else if(matchType(l,argc,1,typeof(System.IO.Stream),typeof(string))){
				System.IO.Stream a1;
				checkType(l,1,out a1);
				System.String a2;
				checkType(l,2,out a2);
				Hugula.Utils.ZipHelper.ExtractGZip(a1,a2);
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
	static public int ExtractGZipByPath_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.String a2;
			checkType(l,2,out a2);
			Hugula.Utils.ZipHelper.ExtractGZipByPath(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int CreateZip_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.Collections.Generic.List<System.String> a2;
			checkType(l,2,out a2);
			System.String a3;
			checkType(l,3,out a3);
			var ret=Hugula.Utils.ZipHelper.CreateZip(a1,a2,a3);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int UnpackZip_s(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(matchType(l,argc,1,typeof(System.Array),typeof(string))){
				System.Array a1;
				checkType(l,1,out a1);
				System.String a2;
				checkType(l,2,out a2);
				Hugula.Utils.ZipHelper.UnpackZip(a1,a2);
				pushValue(l,true);
				return 1;
			}
			else if(matchType(l,argc,1,typeof(System.IO.Stream),typeof(string))){
				System.IO.Stream a1;
				checkType(l,1,out a1);
				System.String a2;
				checkType(l,2,out a2);
				Hugula.Utils.ZipHelper.UnpackZip(a1,a2);
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
	static public int UnpackZipByPath_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.String a2;
			checkType(l,2,out a2);
			Hugula.Utils.ZipHelper.UnpackZipByPath(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int OpenZipFile_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.String a2;
			checkType(l,2,out a2);
			var ret=Hugula.Utils.ZipHelper.OpenZipFile(a1,a2);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Hugula.Utils.ZipHelper");
		addMember(l,CreateGZip_s);
		addMember(l,ExtractGZip_s);
		addMember(l,ExtractGZipByPath_s);
		addMember(l,CreateZip_s);
		addMember(l,UnpackZip_s);
		addMember(l,UnpackZipByPath_s);
		addMember(l,OpenZipFile_s);
		createTypeMetatable(l,constructor, typeof(Hugula.Utils.ZipHelper));
	}
}
