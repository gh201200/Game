using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Hugula_Utils_CUtils : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int GetAssetName_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			var ret=Hugula.Utils.CUtils.GetAssetName(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int GetAssetBundleName_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			var ret=Hugula.Utils.CUtils.GetAssetBundleName(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int GetSuffix_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			var ret=Hugula.Utils.CUtils.GetSuffix(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int CheckWWWUrl_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			var ret=Hugula.Utils.CUtils.CheckWWWUrl(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int InsertAssetBundleName_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.String a2;
			checkType(l,2,out a2);
			var ret=Hugula.Utils.CUtils.InsertAssetBundleName(a1,a2);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int GetUDKey_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			var ret=Hugula.Utils.CUtils.GetUDKey(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int GetRealStreamingAssetsPath_s(IntPtr l) {
		try {
			var ret=Hugula.Utils.CUtils.GetRealStreamingAssetsPath();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int GetRealPersistentDataPath_s(IntPtr l) {
		try {
			var ret=Hugula.Utils.CUtils.GetRealPersistentDataPath();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int GetAssetPath_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			var ret=Hugula.Utils.CUtils.GetAssetPath(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int GetPlatformFolderForAssetBundles_s(IntPtr l) {
		try {
			var ret=Hugula.Utils.CUtils.GetPlatformFolderForAssetBundles();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int GetRightFileName_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			var ret=Hugula.Utils.CUtils.GetRightFileName(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int ConvertDateTimeInt_s(IntPtr l) {
		try {
			System.DateTime a1;
			checkValueType(l,1,out a1);
			var ret=Hugula.Utils.CUtils.ConvertDateTimeInt(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int PathCombine_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.String a2;
			checkType(l,2,out a2);
			var ret=Hugula.Utils.CUtils.PathCombine(a1,a2);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int DebugCastTime_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			var ret=Hugula.Utils.CUtils.DebugCastTime(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_isRelease(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Utils.CUtils.isRelease);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_platform(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Utils.CUtils.platform);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_currPersistentExist(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Utils.CUtils.currPersistentExist);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_currPersistentExist(IntPtr l) {
		try {
			System.Boolean v;
			checkType(l,2,out v);
			Hugula.Utils.CUtils.currPersistentExist=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get__androidFileStreamingAssetsPath(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Utils.CUtils._androidFileStreamingAssetsPath);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set__androidFileStreamingAssetsPath(IntPtr l) {
		try {
			System.String v;
			checkType(l,2,out v);
			Hugula.Utils.CUtils._androidFileStreamingAssetsPath=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_platformFloder(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Utils.CUtils.platformFloder);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_realPersistentDataPath(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Utils.CUtils.realPersistentDataPath);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_realStreamingAssetsPath(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Utils.CUtils.realStreamingAssetsPath);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_androidFileStreamingAssetsPath(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Utils.CUtils.androidFileStreamingAssetsPath);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Hugula.Utils.CUtils");
		addMember(l,GetAssetName_s);
		addMember(l,GetAssetBundleName_s);
		addMember(l,GetSuffix_s);
		addMember(l,CheckWWWUrl_s);
		addMember(l,InsertAssetBundleName_s);
		addMember(l,GetUDKey_s);
		addMember(l,GetRealStreamingAssetsPath_s);
		addMember(l,GetRealPersistentDataPath_s);
		addMember(l,GetAssetPath_s);
		addMember(l,GetPlatformFolderForAssetBundles_s);
		addMember(l,GetRightFileName_s);
		addMember(l,ConvertDateTimeInt_s);
		addMember(l,PathCombine_s);
		addMember(l,DebugCastTime_s);
		addMember(l,"isRelease",get_isRelease,null,false);
		addMember(l,"platform",get_platform,null,false);
		addMember(l,"currPersistentExist",get_currPersistentExist,set_currPersistentExist,false);
		addMember(l,"_androidFileStreamingAssetsPath",get__androidFileStreamingAssetsPath,set__androidFileStreamingAssetsPath,false);
		addMember(l,"platformFloder",get_platformFloder,null,false);
		addMember(l,"realPersistentDataPath",get_realPersistentDataPath,null,false);
		addMember(l,"realStreamingAssetsPath",get_realStreamingAssetsPath,null,false);
		addMember(l,"androidFileStreamingAssetsPath",get_androidFileStreamingAssetsPath,null,false);
		createTypeMetatable(l,null, typeof(Hugula.Utils.CUtils));
	}
}
