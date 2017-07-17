using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Hugula_Loader_LRequest : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int constructor(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			Hugula.Loader.LRequest o;
			if(argc==1){
				o=new Hugula.Loader.LRequest();
				pushValue(l,true);
				pushValue(l,o);
				return 2;
			}
			else if(argc==2){
				System.String a1;
				checkType(l,2,out a1);
				o=new Hugula.Loader.LRequest(a1);
				pushValue(l,true);
				pushValue(l,o);
				return 2;
			}
			else if(argc==4){
				System.String a1;
				checkType(l,2,out a1);
				System.String a2;
				checkType(l,3,out a2);
				System.Type a3;
				checkType(l,4,out a3);
				o=new Hugula.Loader.LRequest(a1,a2,a3);
				pushValue(l,true);
				pushValue(l,o);
				return 2;
			}
			return error(l,"New object failed.");
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Dispose(IntPtr l) {
		try {
			Hugula.Loader.LRequest self=(Hugula.Loader.LRequest)checkSelf(l);
			self.Dispose();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Get_s(IntPtr l) {
		try {
			var ret=Hugula.Loader.LRequest.Get();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Release_s(IntPtr l) {
		try {
			Hugula.Loader.CRequest a1;
			checkType(l,1,out a1);
			Hugula.Loader.LRequest.Release(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_onCompleteFn(IntPtr l) {
		try {
			Hugula.Loader.LRequest self=(Hugula.Loader.LRequest)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onCompleteFn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_onCompleteFn(IntPtr l) {
		try {
			Hugula.Loader.LRequest self=(Hugula.Loader.LRequest)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.onCompleteFn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_onEndFn(IntPtr l) {
		try {
			Hugula.Loader.LRequest self=(Hugula.Loader.LRequest)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onEndFn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_onEndFn(IntPtr l) {
		try {
			Hugula.Loader.LRequest self=(Hugula.Loader.LRequest)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.onEndFn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Hugula.Loader.LRequest");
		addMember(l,Dispose);
		addMember(l,Get_s);
		addMember(l,Release_s);
		addMember(l,"onCompleteFn",get_onCompleteFn,set_onCompleteFn,true);
		addMember(l,"onEndFn",get_onEndFn,set_onEndFn,true);
		createTypeMetatable(l,constructor, typeof(Hugula.Loader.LRequest),typeof(Hugula.Loader.CRequest));
	}
}
