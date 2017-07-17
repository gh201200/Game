using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Hugula_Loader_CCar : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int constructor(IntPtr l) {
		try {
			Hugula.Loader.CCar o;
			o=new Hugula.Loader.CCar();
			pushValue(l,true);
			pushValue(l,o);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Update(IntPtr l) {
		try {
			Hugula.Loader.CCar self=(Hugula.Loader.CCar)checkSelf(l);
			self.Update();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int BeginLoad(IntPtr l) {
		try {
			Hugula.Loader.CCar self=(Hugula.Loader.CCar)checkSelf(l);
			Hugula.Loader.CRequest a1;
			checkType(l,2,out a1);
			self.BeginLoad(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int StopLoad(IntPtr l) {
		try {
			Hugula.Loader.CCar self=(Hugula.Loader.CCar)checkSelf(l);
			self.StopLoad();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_enabled(IntPtr l) {
		try {
			Hugula.Loader.CCar self=(Hugula.Loader.CCar)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.enabled);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_enabled(IntPtr l) {
		try {
			Hugula.Loader.CCar self=(Hugula.Loader.CCar)checkSelf(l);
			System.Boolean v;
			checkType(l,2,out v);
			self.enabled=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_OnProcess(IntPtr l) {
		try {
			Hugula.Loader.CCar self=(Hugula.Loader.CCar)checkSelf(l);
			System.Action<Hugula.Loader.CCar,System.Single> v;
			int op=LuaDelegation.checkDelegate(l,2,out v);
			if(op==0) self.OnProcess=v;
			else if(op==1) self.OnProcess+=v;
			else if(op==2) self.OnProcess-=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_OnComplete(IntPtr l) {
		try {
			Hugula.Loader.CCar self=(Hugula.Loader.CCar)checkSelf(l);
			System.Action<Hugula.Loader.CCar,Hugula.Loader.CRequest> v;
			int op=LuaDelegation.checkDelegate(l,2,out v);
			if(op==0) self.OnComplete=v;
			else if(op==1) self.OnComplete+=v;
			else if(op==2) self.OnComplete-=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_OnError(IntPtr l) {
		try {
			Hugula.Loader.CCar self=(Hugula.Loader.CCar)checkSelf(l);
			System.Action<Hugula.Loader.CCar,Hugula.Loader.CRequest> v;
			int op=LuaDelegation.checkDelegate(l,2,out v);
			if(op==0) self.OnError=v;
			else if(op==1) self.OnError+=v;
			else if(op==2) self.OnError-=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_isFree(IntPtr l) {
		try {
			Hugula.Loader.CCar self=(Hugula.Loader.CCar)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.isFree);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_req(IntPtr l) {
		try {
			Hugula.Loader.CCar self=(Hugula.Loader.CCar)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.req);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Hugula.Loader.CCar");
		addMember(l,Update);
		addMember(l,BeginLoad);
		addMember(l,StopLoad);
		addMember(l,"enabled",get_enabled,set_enabled,true);
		addMember(l,"OnProcess",null,set_OnProcess,true);
		addMember(l,"OnComplete",null,set_OnComplete,true);
		addMember(l,"OnError",null,set_OnError,true);
		addMember(l,"isFree",get_isFree,null,true);
		addMember(l,"req",get_req,null,true);
		createTypeMetatable(l,constructor, typeof(Hugula.Loader.CCar));
	}
}
