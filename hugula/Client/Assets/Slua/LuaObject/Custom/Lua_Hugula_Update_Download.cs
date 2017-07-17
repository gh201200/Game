using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Hugula_Update_Download : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Init(IntPtr l) {
		try {
			Hugula.Update.Download self=(Hugula.Update.Download)checkSelf(l);
			System.String[] a1;
			checkArray(l,2,out a1);
			System.Int32 a2;
			checkType(l,3,out a2);
			System.Action<System.String,System.Boolean,System.Object> a3;
			LuaDelegation.checkDelegate(l,4,out a3);
			System.Action<System.Boolean> a4;
			LuaDelegation.checkDelegate(l,5,out a4);
			self.Init(a1,a2,a3,a4);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Load(IntPtr l) {
		try {
			Hugula.Update.Download self=(Hugula.Update.Download)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			System.String a2;
			checkType(l,3,out a2);
			System.Object a3;
			checkType(l,4,out a3);
			self.Load(a1,a2,a3);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Dispose_s(IntPtr l) {
		try {
			Hugula.Update.Download.Dispose();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_progressPercentage(IntPtr l) {
		try {
			Hugula.Update.Download self=(Hugula.Update.Download)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.progressPercentage);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_maxLoading(IntPtr l) {
		try {
			Hugula.Update.Download self=(Hugula.Update.Download)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.maxLoading);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_instance(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Update.Download.instance);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Hugula.Update.Download");
		addMember(l,Init);
		addMember(l,Load);
		addMember(l,Dispose_s);
		addMember(l,"progressPercentage",get_progressPercentage,null,true);
		addMember(l,"maxLoading",get_maxLoading,null,true);
		addMember(l,"instance",get_instance,null,false);
		createTypeMetatable(l,null, typeof(Hugula.Update.Download),typeof(UnityEngine.MonoBehaviour));
	}
}
