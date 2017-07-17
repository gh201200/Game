using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Hugula_Cryptograph_CryptographHelper : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int constructor(IntPtr l) {
		try {
			Hugula.Cryptograph.CryptographHelper o;
			o=new Hugula.Cryptograph.CryptographHelper();
			pushValue(l,true);
			pushValue(l,o);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int CrypfString_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.String a2;
			checkType(l,2,out a2);
			var ret=Hugula.Cryptograph.CryptographHelper.CrypfString(a1,a2);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Decrypt_s(IntPtr l) {
		try {
			System.Byte[] a1;
			checkArray(l,1,out a1);
			System.Byte[] a2;
			checkArray(l,2,out a2);
			System.Byte[] a3;
			checkArray(l,3,out a3);
			var ret=Hugula.Cryptograph.CryptographHelper.Decrypt(a1,a2,a3);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Encrypt_s(IntPtr l) {
		try {
			System.Byte[] a1;
			checkArray(l,1,out a1);
			System.Byte[] a2;
			checkArray(l,2,out a2);
			System.Byte[] a3;
			checkArray(l,3,out a3);
			var ret=Hugula.Cryptograph.CryptographHelper.Encrypt(a1,a2,a3);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Md5String_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			var ret=Hugula.Cryptograph.CryptographHelper.Md5String(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Md5Bytes_s(IntPtr l) {
		try {
			System.Byte[] a1;
			checkArray(l,1,out a1);
			var ret=Hugula.Cryptograph.CryptographHelper.Md5Bytes(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Md5BytesTo32_s(IntPtr l) {
		try {
			System.Byte[] a1;
			checkArray(l,1,out a1);
			var ret=Hugula.Cryptograph.CryptographHelper.Md5BytesTo32(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Base64ToString_s(IntPtr l) {
		try {
			System.Byte[] a1;
			checkArray(l,1,out a1);
			var ret=Hugula.Cryptograph.CryptographHelper.Base64ToString(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Base64ToBinary_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			var ret=Hugula.Cryptograph.CryptographHelper.Base64ToBinary(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Hugula.Cryptograph.CryptographHelper");
		addMember(l,CrypfString_s);
		addMember(l,Decrypt_s);
		addMember(l,Encrypt_s);
		addMember(l,Md5String_s);
		addMember(l,Md5Bytes_s);
		addMember(l,Md5BytesTo32_s);
		addMember(l,Base64ToString_s);
		addMember(l,Base64ToBinary_s);
		createTypeMetatable(l,constructor, typeof(Hugula.Cryptograph.CryptographHelper));
	}
}
