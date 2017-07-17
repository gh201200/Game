using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Hugula_Loader_GroupRequestRecord : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int constructor(IntPtr l) {
		try {
			Hugula.Loader.GroupRequestRecord o;
			o=new Hugula.Loader.GroupRequestRecord();
			pushValue(l,true);
			pushValue(l,o);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Progress(IntPtr l) {
		try {
			Hugula.Loader.GroupRequestRecord self=(Hugula.Loader.GroupRequestRecord)checkSelf(l);
			self.Progress();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Add(IntPtr l) {
		try {
			Hugula.Loader.GroupRequestRecord self=(Hugula.Loader.GroupRequestRecord)checkSelf(l);
			Hugula.Loader.CRequest a1;
			checkType(l,2,out a1);
			self.Add(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Complete(IntPtr l) {
		try {
			Hugula.Loader.GroupRequestRecord self=(Hugula.Loader.GroupRequestRecord)checkSelf(l);
			Hugula.Loader.CRequest a1;
			checkType(l,2,out a1);
			self.Complete(a1);
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
			var ret=Hugula.Loader.GroupRequestRecord.Get();
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
			Hugula.Loader.GroupRequestRecord a1;
			checkType(l,1,out a1);
			Hugula.Loader.GroupRequestRecord.Release(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_onGroupComplate(IntPtr l) {
		try {
			Hugula.Loader.GroupRequestRecord self=(Hugula.Loader.GroupRequestRecord)checkSelf(l);
			System.Action<System.Object> v;
			int op=LuaDelegation.checkDelegate(l,2,out v);
			if(op==0) self.onGroupComplate=v;
			else if(op==1) self.onGroupComplate+=v;
			else if(op==2) self.onGroupComplate-=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_onGroupProgress(IntPtr l) {
		try {
			Hugula.Loader.GroupRequestRecord self=(Hugula.Loader.GroupRequestRecord)checkSelf(l);
			System.Action<Hugula.Loader.LoadingEventArg> v;
			int op=LuaDelegation.checkDelegate(l,2,out v);
			if(op==0) self.onGroupProgress=v;
			else if(op==1) self.onGroupProgress+=v;
			else if(op==2) self.onGroupProgress-=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_Total(IntPtr l) {
		try {
			Hugula.Loader.GroupRequestRecord self=(Hugula.Loader.GroupRequestRecord)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.Total);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_Total(IntPtr l) {
		try {
			Hugula.Loader.GroupRequestRecord self=(Hugula.Loader.GroupRequestRecord)checkSelf(l);
			System.Int32 v;
			checkType(l,2,out v);
			self.Total=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_Count(IntPtr l) {
		try {
			Hugula.Loader.GroupRequestRecord self=(Hugula.Loader.GroupRequestRecord)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.Count);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_Count(IntPtr l) {
		try {
			Hugula.Loader.GroupRequestRecord self=(Hugula.Loader.GroupRequestRecord)checkSelf(l);
			int v;
			checkType(l,2,out v);
			self.Count=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Hugula.Loader.GroupRequestRecord");
		addMember(l,Progress);
		addMember(l,Add);
		addMember(l,Complete);
		addMember(l,Get_s);
		addMember(l,Release_s);
		addMember(l,"onGroupComplate",null,set_onGroupComplate,true);
		addMember(l,"onGroupProgress",null,set_onGroupProgress,true);
		addMember(l,"Total",get_Total,set_Total,true);
		addMember(l,"Count",get_Count,set_Count,true);
		createTypeMetatable(l,constructor, typeof(Hugula.Loader.GroupRequestRecord));
	}
}
