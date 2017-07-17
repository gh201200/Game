using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Hugula_HugulaSetting : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int constructor(IntPtr l) {
		try {
			Hugula.HugulaSetting o;
			o=new Hugula.HugulaSetting();
			pushValue(l,true);
			pushValue(l,o);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int AddVariant(IntPtr l) {
		try {
			Hugula.HugulaSetting self=(Hugula.HugulaSetting)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			self.AddVariant(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int ContainsVariant(IntPtr l) {
		try {
			Hugula.HugulaSetting self=(Hugula.HugulaSetting)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			var ret=self.ContainsVariant(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_spliteExtensionFolder(IntPtr l) {
		try {
			Hugula.HugulaSetting self=(Hugula.HugulaSetting)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.spliteExtensionFolder);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_spliteExtensionFolder(IntPtr l) {
		try {
			Hugula.HugulaSetting self=(Hugula.HugulaSetting)checkSelf(l);
			System.Boolean v;
			checkType(l,2,out v);
			self.spliteExtensionFolder=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_backupResType(IntPtr l) {
		try {
			Hugula.HugulaSetting self=(Hugula.HugulaSetting)checkSelf(l);
			pushValue(l,true);
			pushEnum(l,(int)self.backupResType);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_backupResType(IntPtr l) {
		try {
			Hugula.HugulaSetting self=(Hugula.HugulaSetting)checkSelf(l);
			Hugula.CopyResType v;
			checkEnum(l,2,out v);
			self.backupResType=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_inclusionVariants(IntPtr l) {
		try {
			Hugula.HugulaSetting self=(Hugula.HugulaSetting)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.inclusionVariants);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_inclusionVariants(IntPtr l) {
		try {
			Hugula.HugulaSetting self=(Hugula.HugulaSetting)checkSelf(l);
			System.Collections.Generic.List<System.String> v;
			checkType(l,2,out v);
			self.inclusionVariants=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_allVariants(IntPtr l) {
		try {
			Hugula.HugulaSetting self=(Hugula.HugulaSetting)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.allVariants);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_allVariants(IntPtr l) {
		try {
			Hugula.HugulaSetting self=(Hugula.HugulaSetting)checkSelf(l);
			System.Collections.Generic.List<System.String> v;
			checkType(l,2,out v);
			self.allVariants=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_appendCrcToFile(IntPtr l) {
		try {
			Hugula.HugulaSetting self=(Hugula.HugulaSetting)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.appendCrcToFile);
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
			pushValue(l,Hugula.HugulaSetting.instance);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Hugula.HugulaSetting");
		addMember(l,AddVariant);
		addMember(l,ContainsVariant);
		addMember(l,"spliteExtensionFolder",get_spliteExtensionFolder,set_spliteExtensionFolder,true);
		addMember(l,"backupResType",get_backupResType,set_backupResType,true);
		addMember(l,"inclusionVariants",get_inclusionVariants,set_inclusionVariants,true);
		addMember(l,"allVariants",get_allVariants,set_allVariants,true);
		addMember(l,"appendCrcToFile",get_appendCrcToFile,null,true);
		addMember(l,"instance",get_instance,null,false);
		createTypeMetatable(l,constructor, typeof(Hugula.HugulaSetting),typeof(UnityEngine.ScriptableObject));
	}
}
