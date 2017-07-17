using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_LeanAudioStream : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int constructor(IntPtr l) {
		try {
			LeanAudioStream o;
			System.Single[] a1;
			checkArray(l,2,out a1);
			o=new LeanAudioStream(a1);
			pushValue(l,true);
			pushValue(l,o);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int OnAudioRead(IntPtr l) {
		try {
			LeanAudioStream self=(LeanAudioStream)checkSelf(l);
			System.Single[] a1;
			checkArray(l,2,out a1);
			self.OnAudioRead(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int OnAudioSetPosition(IntPtr l) {
		try {
			LeanAudioStream self=(LeanAudioStream)checkSelf(l);
			System.Int32 a1;
			checkType(l,2,out a1);
			self.OnAudioSetPosition(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_position(IntPtr l) {
		try {
			LeanAudioStream self=(LeanAudioStream)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.position);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_position(IntPtr l) {
		try {
			LeanAudioStream self=(LeanAudioStream)checkSelf(l);
			System.Int32 v;
			checkType(l,2,out v);
			self.position=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_audioClip(IntPtr l) {
		try {
			LeanAudioStream self=(LeanAudioStream)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.audioClip);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_audioClip(IntPtr l) {
		try {
			LeanAudioStream self=(LeanAudioStream)checkSelf(l);
			UnityEngine.AudioClip v;
			checkType(l,2,out v);
			self.audioClip=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_audioArr(IntPtr l) {
		try {
			LeanAudioStream self=(LeanAudioStream)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.audioArr);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_audioArr(IntPtr l) {
		try {
			LeanAudioStream self=(LeanAudioStream)checkSelf(l);
			System.Single[] v;
			checkArray(l,2,out v);
			self.audioArr=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"LeanAudioStream");
		addMember(l,OnAudioRead);
		addMember(l,OnAudioSetPosition);
		addMember(l,"position",get_position,set_position,true);
		addMember(l,"audioClip",get_audioClip,set_audioClip,true);
		addMember(l,"audioArr",get_audioArr,set_audioArr,true);
		createTypeMetatable(l,constructor, typeof(LeanAudioStream));
	}
}
