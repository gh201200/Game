using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Hugula_Utils_Common : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int constructor(IntPtr l) {
		try {
			Hugula.Utils.Common o;
			o=new Hugula.Utils.Common();
			pushValue(l,true);
			pushValue(l,o);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_ASSETBUNDLE_SUFFIX(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Utils.Common.ASSETBUNDLE_SUFFIX);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_CHECK_ASSETBUNDLE_SUFFIX(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Utils.Common.CHECK_ASSETBUNDLE_SUFFIX);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_DOT_BYTES(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Utils.Common.DOT_BYTES);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_CRC32_FILELIST_NAME(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Utils.Common.CRC32_FILELIST_NAME);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_CRC32_VER_FILENAME(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Utils.Common.CRC32_VER_FILENAME);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_CONFIG_CSV_NAME(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Utils.Common.CONFIG_CSV_NAME);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_HTTP_STRING(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Utils.Common.HTTP_STRING);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_HTTPS_STRING(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Utils.Common.HTTPS_STRING);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_JAR_FILE(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Utils.Common.JAR_FILE);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_IS_WEB_MODE(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Utils.Common.IS_WEB_MODE);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Hugula.Utils.Common");
		addMember(l,"ASSETBUNDLE_SUFFIX",get_ASSETBUNDLE_SUFFIX,null,false);
		addMember(l,"CHECK_ASSETBUNDLE_SUFFIX",get_CHECK_ASSETBUNDLE_SUFFIX,null,false);
		addMember(l,"DOT_BYTES",get_DOT_BYTES,null,false);
		addMember(l,"CRC32_FILELIST_NAME",get_CRC32_FILELIST_NAME,null,false);
		addMember(l,"CRC32_VER_FILENAME",get_CRC32_VER_FILENAME,null,false);
		addMember(l,"CONFIG_CSV_NAME",get_CONFIG_CSV_NAME,null,false);
		addMember(l,"HTTP_STRING",get_HTTP_STRING,null,false);
		addMember(l,"HTTPS_STRING",get_HTTPS_STRING,null,false);
		addMember(l,"JAR_FILE",get_JAR_FILE,null,false);
		addMember(l,"IS_WEB_MODE",get_IS_WEB_MODE,null,false);
		createTypeMetatable(l,constructor, typeof(Hugula.Utils.Common));
	}
}
