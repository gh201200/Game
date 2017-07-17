using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Hugula_Loader_CResLoader : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int LoadReq(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==2){
				Hugula.Loader.CResLoader self=(Hugula.Loader.CResLoader)checkSelf(l);
				Hugula.Loader.CRequest a1;
				checkType(l,2,out a1);
				self.LoadReq(a1);
				pushValue(l,true);
				return 1;
			}
			else if(argc==3){
				Hugula.Loader.CResLoader self=(Hugula.Loader.CResLoader)checkSelf(l);
				Hugula.Loader.CRequest a1;
				checkType(l,2,out a1);
				Hugula.Loader.GroupRequestRecord a2;
				checkType(l,3,out a2);
				self.LoadReq(a1,a2);
				pushValue(l,true);
				return 1;
			}
			else if(argc==4){
				Hugula.Loader.CResLoader self=(Hugula.Loader.CResLoader)checkSelf(l);
				System.Collections.Generic.IList<Hugula.Loader.CRequest> a1;
				checkType(l,2,out a1);
				System.Action<System.Object> a2;
				LuaDelegation.checkDelegate(l,3,out a2);
				System.Action<Hugula.Loader.LoadingEventArg> a3;
				LuaDelegation.checkDelegate(l,4,out a3);
				self.LoadReq(a1,a2,a3);
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
	static public int StopReq(IntPtr l) {
		try {
			Hugula.Loader.CResLoader self=(Hugula.Loader.CResLoader)checkSelf(l);
			Hugula.Loader.CRequest a1;
			checkType(l,2,out a1);
			self.StopReq(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int StopURL(IntPtr l) {
		try {
			Hugula.Loader.CResLoader self=(Hugula.Loader.CResLoader)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			self.StopURL(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int StopAll(IntPtr l) {
		try {
			Hugula.Loader.CResLoader self=(Hugula.Loader.CResLoader)checkSelf(l);
			self.StopAll();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int RemoveAllEvents(IntPtr l) {
		try {
			Hugula.Loader.CResLoader self=(Hugula.Loader.CResLoader)checkSelf(l);
			self.RemoveAllEvents();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_currentLoaded(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Loader.CResLoader.currentLoaded);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_currentLoaded(IntPtr l) {
		try {
			System.Int32 v;
			checkType(l,2,out v);
			Hugula.Loader.CResLoader.currentLoaded=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_assetBundleManifest(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Loader.CResLoader.assetBundleManifest);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_assetBundleManifest(IntPtr l) {
		try {
			UnityEngine.AssetBundleManifest v;
			checkType(l,2,out v);
			Hugula.Loader.CResLoader.assetBundleManifest=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_OnAllComplete(IntPtr l) {
		try {
			Hugula.Loader.CResLoader self=(Hugula.Loader.CResLoader)checkSelf(l);
			System.Action<Hugula.Loader.CResLoader> v;
			int op=LuaDelegation.checkDelegate(l,2,out v);
			if(op==0) self.OnAllComplete=v;
			else if(op==1) self.OnAllComplete+=v;
			else if(op==2) self.OnAllComplete-=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_OnProgress(IntPtr l) {
		try {
			Hugula.Loader.CResLoader self=(Hugula.Loader.CResLoader)checkSelf(l);
			System.Action<Hugula.Loader.LoadingEventArg> v;
			int op=LuaDelegation.checkDelegate(l,2,out v);
			if(op==0) self.OnProgress=v;
			else if(op==1) self.OnProgress+=v;
			else if(op==2) self.OnProgress-=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_OnSharedComplete(IntPtr l) {
		try {
			Hugula.Loader.CResLoader self=(Hugula.Loader.CResLoader)checkSelf(l);
			System.Action<Hugula.Loader.CRequest> v;
			int op=LuaDelegation.checkDelegate(l,2,out v);
			if(op==0) self.OnSharedComplete=v;
			else if(op==1) self.OnSharedComplete+=v;
			else if(op==2) self.OnSharedComplete-=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_OnSharedErr(IntPtr l) {
		try {
			Hugula.Loader.CResLoader self=(Hugula.Loader.CResLoader)checkSelf(l);
			System.Action<Hugula.Loader.CRequest> v;
			int op=LuaDelegation.checkDelegate(l,2,out v);
			if(op==0) self.OnSharedErr=v;
			else if(op==1) self.OnSharedErr+=v;
			else if(op==2) self.OnSharedErr-=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_OnAssetBundleComplete(IntPtr l) {
		try {
			Hugula.Loader.CResLoader self=(Hugula.Loader.CResLoader)checkSelf(l);
			System.Action<Hugula.Loader.CRequest> v;
			int op=LuaDelegation.checkDelegate(l,2,out v);
			if(op==0) self.OnAssetBundleComplete=v;
			else if(op==1) self.OnAssetBundleComplete+=v;
			else if(op==2) self.OnAssetBundleComplete-=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_OnAssetBundleErr(IntPtr l) {
		try {
			Hugula.Loader.CResLoader self=(Hugula.Loader.CResLoader)checkSelf(l);
			System.Action<Hugula.Loader.CRequest> v;
			int op=LuaDelegation.checkDelegate(l,2,out v);
			if(op==0) self.OnAssetBundleErr=v;
			else if(op==1) self.OnAssetBundleErr+=v;
			else if(op==2) self.OnAssetBundleErr-=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_maxLoading(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Loader.CResLoader.maxLoading);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_maxLoading(IntPtr l) {
		try {
			int v;
			checkType(l,2,out v);
			Hugula.Loader.CResLoader.maxLoading=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_totalLoading(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Loader.CResLoader.totalLoading);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_currentLoading(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Loader.CResLoader.currentLoading);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_uriList(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Loader.CResLoader.uriList);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_uriList(IntPtr l) {
		try {
			Hugula.Loader.UriGroup v;
			checkType(l,2,out v);
			Hugula.Loader.CResLoader.uriList=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_ActiveVariants(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Loader.CResLoader.ActiveVariants);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_ActiveVariants(IntPtr l) {
		try {
			System.String[] v;
			checkArray(l,2,out v);
			Hugula.Loader.CResLoader.ActiveVariants=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Hugula.Loader.CResLoader");
		addMember(l,LoadReq);
		addMember(l,StopReq);
		addMember(l,StopURL);
		addMember(l,StopAll);
		addMember(l,RemoveAllEvents);
		addMember(l,"currentLoaded",get_currentLoaded,set_currentLoaded,false);
		addMember(l,"assetBundleManifest",get_assetBundleManifest,set_assetBundleManifest,false);
		addMember(l,"OnAllComplete",null,set_OnAllComplete,true);
		addMember(l,"OnProgress",null,set_OnProgress,true);
		addMember(l,"OnSharedComplete",null,set_OnSharedComplete,true);
		addMember(l,"OnSharedErr",null,set_OnSharedErr,true);
		addMember(l,"OnAssetBundleComplete",null,set_OnAssetBundleComplete,true);
		addMember(l,"OnAssetBundleErr",null,set_OnAssetBundleErr,true);
		addMember(l,"maxLoading",get_maxLoading,set_maxLoading,false);
		addMember(l,"totalLoading",get_totalLoading,null,false);
		addMember(l,"currentLoading",get_currentLoading,null,false);
		addMember(l,"uriList",get_uriList,set_uriList,false);
		addMember(l,"ActiveVariants",get_ActiveVariants,set_ActiveVariants,false);
		createTypeMetatable(l,null, typeof(Hugula.Loader.CResLoader),typeof(UnityEngine.MonoBehaviour));
	}
}
