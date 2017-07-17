using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Hugula_Loader_UriGroup : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int constructor(IntPtr l) {
		try {
			Hugula.Loader.UriGroup o;
			o=new Hugula.Loader.UriGroup();
			pushValue(l,true);
			pushValue(l,o);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Add(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==2){
				Hugula.Loader.UriGroup self=(Hugula.Loader.UriGroup)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				var ret=self.Add(a1);
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
			}
			else if(argc==3){
				Hugula.Loader.UriGroup self=(Hugula.Loader.UriGroup)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				System.Boolean a2;
				checkType(l,3,out a2);
				self.Add(a1,a2);
				pushValue(l,true);
				return 1;
			}
			else if(argc==4){
				Hugula.Loader.UriGroup self=(Hugula.Loader.UriGroup)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				System.Action<Hugula.Loader.CRequest,System.Array> a2;
				LuaDelegation.checkDelegate(l,3,out a2);
				System.Func<Hugula.Loader.CRequest,System.Boolean> a3;
				LuaDelegation.checkDelegate(l,4,out a3);
				self.Add(a1,a2,a3);
				pushValue(l,true);
				return 1;
			}
			else if(matchType(l,argc,2,typeof(string),typeof(System.Action<Hugula.Loader.CRequest,System.Array>),typeof(System.Func<Hugula.Loader.CRequest,System.Boolean>),typeof(System.Func<Hugula.Loader.CRequest,System.String>))){
				Hugula.Loader.UriGroup self=(Hugula.Loader.UriGroup)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				System.Action<Hugula.Loader.CRequest,System.Array> a2;
				LuaDelegation.checkDelegate(l,3,out a2);
				System.Func<Hugula.Loader.CRequest,System.Boolean> a3;
				LuaDelegation.checkDelegate(l,4,out a3);
				System.Func<Hugula.Loader.CRequest,System.String> a4;
				LuaDelegation.checkDelegate(l,5,out a4);
				self.Add(a1,a2,a3,a4);
				pushValue(l,true);
				return 1;
			}
			else if(matchType(l,argc,2,typeof(string),typeof(bool),typeof(bool),typeof(bool))){
				Hugula.Loader.UriGroup self=(Hugula.Loader.UriGroup)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				System.Boolean a2;
				checkType(l,3,out a2);
				System.Boolean a3;
				checkType(l,4,out a3);
				System.Boolean a4;
				checkType(l,5,out a4);
				self.Add(a1,a2,a3,a4);
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
	static public int CheckUriCrc(IntPtr l) {
		try {
			Hugula.Loader.UriGroup self=(Hugula.Loader.UriGroup)checkSelf(l);
			Hugula.Loader.CRequest a1;
			checkType(l,2,out a1);
			var ret=self.CheckUriCrc(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int GetUri(IntPtr l) {
		try {
			Hugula.Loader.UriGroup self=(Hugula.Loader.UriGroup)checkSelf(l);
			System.Int32 a1;
			checkType(l,2,out a1);
			var ret=self.GetUri(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Clear(IntPtr l) {
		try {
			Hugula.Loader.UriGroup self=(Hugula.Loader.UriGroup)checkSelf(l);
			self.Clear();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int CheckAndSetNextUriGroup_s(IntPtr l) {
		try {
			Hugula.Loader.CRequest a1;
			checkType(l,1,out a1);
			var ret=Hugula.Loader.UriGroup.CheckAndSetNextUriGroup(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int CheckRequestCurrentIndexCrc_s(IntPtr l) {
		try {
			Hugula.Loader.CRequest a1;
			checkType(l,1,out a1);
			var ret=Hugula.Loader.UriGroup.CheckRequestCurrentIndexCrc(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int CheckWWWComplete_s(IntPtr l) {
		try {
			Hugula.Loader.CRequest a1;
			checkType(l,1,out a1);
			UnityEngine.WWW a2;
			checkType(l,2,out a2);
			Hugula.Loader.UriGroup.CheckWWWComplete(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int CheckRequestUrlIsAssetbundle_s(IntPtr l) {
		try {
			Hugula.Loader.CRequest a1;
			checkType(l,1,out a1);
			var ret=Hugula.Loader.UriGroup.CheckRequestUrlIsAssetbundle(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int SaveWWWFileToPersistent_s(IntPtr l) {
		try {
			Hugula.Loader.CRequest a1;
			checkType(l,1,out a1);
			System.Array a2;
			checkType(l,2,out a2);
			Hugula.Loader.UriGroup.SaveWWWFileToPersistent(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int OverrideRequestUrlByCrc_s(IntPtr l) {
		try {
			Hugula.Loader.CRequest a1;
			checkType(l,1,out a1);
			var ret=Hugula.Loader.UriGroup.OverrideRequestUrlByCrc(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_count(IntPtr l) {
		try {
			Hugula.Loader.UriGroup self=(Hugula.Loader.UriGroup)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.count);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Hugula.Loader.UriGroup");
		addMember(l,Add);
		addMember(l,CheckUriCrc);
		addMember(l,GetUri);
		addMember(l,Clear);
		addMember(l,CheckAndSetNextUriGroup_s);
		addMember(l,CheckRequestCurrentIndexCrc_s);
		addMember(l,CheckWWWComplete_s);
		addMember(l,CheckRequestUrlIsAssetbundle_s);
		addMember(l,SaveWWWFileToPersistent_s);
		addMember(l,OverrideRequestUrlByCrc_s);
		addMember(l,"count",get_count,null,true);
		createTypeMetatable(l,constructor, typeof(Hugula.Loader.UriGroup));
	}
}
