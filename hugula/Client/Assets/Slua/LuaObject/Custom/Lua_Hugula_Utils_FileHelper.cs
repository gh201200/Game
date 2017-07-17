using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Hugula_Utils_FileHelper : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int constructor(IntPtr l) {
		try {
			Hugula.Utils.FileHelper o;
			o=new Hugula.Utils.FileHelper();
			pushValue(l,true);
			pushValue(l,o);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int SavePersistentFile_s(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(matchType(l,argc,1,typeof(string),typeof(string))){
				System.String a1;
				checkType(l,1,out a1);
				System.String a2;
				checkType(l,2,out a2);
				Hugula.Utils.FileHelper.SavePersistentFile(a1,a2);
				pushValue(l,true);
				return 1;
			}
			else if(matchType(l,argc,1,typeof(System.Array),typeof(string))){
				System.Array a1;
				checkType(l,1,out a1);
				System.String a2;
				checkType(l,2,out a2);
				Hugula.Utils.FileHelper.SavePersistentFile(a1,a2);
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
	static public int ReadPersistentFile_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			var ret=Hugula.Utils.FileHelper.ReadPersistentFile(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int ChangePersistentFileName_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.String a2;
			checkType(l,2,out a2);
			var ret=Hugula.Utils.FileHelper.ChangePersistentFileName(a1,a2);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int DeletePersistentFile_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			Hugula.Utils.FileHelper.DeletePersistentFile(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int DeletePersistentDirectoryFiles_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			Hugula.Utils.FileHelper.DeletePersistentDirectoryFiles(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int PersistentFileExists_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			var ret=Hugula.Utils.FileHelper.PersistentFileExists(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int ComputeCrc32_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			var ret=Hugula.Utils.FileHelper.ComputeCrc32(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int UnpackConfigAssetBundleFn_s(IntPtr l) {
		try {
			UnityEngine.AssetBundle a1;
			checkType(l,1,out a1);
			SLua.LuaFunction a2;
			checkType(l,2,out a2);
			Hugula.Utils.FileHelper.UnpackConfigAssetBundleFn(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int CheckCreateFilePathDirectory_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			Hugula.Utils.FileHelper.CheckCreateFilePathDirectory(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int FileExists_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			var ret=Hugula.Utils.FileHelper.FileExists(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Hugula.Utils.FileHelper");
		addMember(l,SavePersistentFile_s);
		addMember(l,ReadPersistentFile_s);
		addMember(l,ChangePersistentFileName_s);
		addMember(l,DeletePersistentFile_s);
		addMember(l,DeletePersistentDirectoryFiles_s);
		addMember(l,PersistentFileExists_s);
		addMember(l,ComputeCrc32_s);
		addMember(l,UnpackConfigAssetBundleFn_s);
		addMember(l,CheckCreateFilePathDirectory_s);
		addMember(l,FileExists_s);
		createTypeMetatable(l,constructor, typeof(Hugula.Utils.FileHelper));
	}
}
