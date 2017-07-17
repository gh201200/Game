using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_LeanAudio : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int constructor(IntPtr l) {
		try {
			LeanAudio o;
			o=new LeanAudio();
			pushValue(l,true);
			pushValue(l,o);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int options_s(IntPtr l) {
		try {
			var ret=LeanAudio.options();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int createAudioStream_s(IntPtr l) {
		try {
			UnityEngine.AnimationCurve a1;
			checkType(l,1,out a1);
			UnityEngine.AnimationCurve a2;
			checkType(l,2,out a2);
			LeanAudioOptions a3;
			checkType(l,3,out a3);
			var ret=LeanAudio.createAudioStream(a1,a2,a3);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int createAudio_s(IntPtr l) {
		try {
			UnityEngine.AnimationCurve a1;
			checkType(l,1,out a1);
			UnityEngine.AnimationCurve a2;
			checkType(l,2,out a2);
			LeanAudioOptions a3;
			checkType(l,3,out a3);
			var ret=LeanAudio.createAudio(a1,a2,a3);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int generateAudioFromCurve_s(IntPtr l) {
		try {
			UnityEngine.AnimationCurve a1;
			checkType(l,1,out a1);
			System.Int32 a2;
			checkType(l,2,out a2);
			var ret=LeanAudio.generateAudioFromCurve(a1,a2);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int play_s(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==1){
				UnityEngine.AudioClip a1;
				checkType(l,1,out a1);
				var ret=LeanAudio.play(a1);
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
			}
			else if(matchType(l,argc,1,typeof(UnityEngine.AudioClip),typeof(UnityEngine.Vector3))){
				UnityEngine.AudioClip a1;
				checkType(l,1,out a1);
				UnityEngine.Vector3 a2;
				checkType(l,2,out a2);
				var ret=LeanAudio.play(a1,a2);
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
			}
			else if(matchType(l,argc,1,typeof(UnityEngine.AudioClip),typeof(float))){
				UnityEngine.AudioClip a1;
				checkType(l,1,out a1);
				System.Single a2;
				checkType(l,2,out a2);
				var ret=LeanAudio.play(a1,a2);
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
			}
			else if(argc==3){
				UnityEngine.AudioClip a1;
				checkType(l,1,out a1);
				UnityEngine.Vector3 a2;
				checkType(l,2,out a2);
				System.Single a3;
				checkType(l,3,out a3);
				var ret=LeanAudio.play(a1,a2,a3);
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
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
	static public int playClipAt_s(IntPtr l) {
		try {
			UnityEngine.AudioClip a1;
			checkType(l,1,out a1);
			UnityEngine.Vector3 a2;
			checkType(l,2,out a2);
			var ret=LeanAudio.playClipAt(a1,a2);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int printOutAudioClip_s(IntPtr l) {
		try {
			UnityEngine.AudioClip a1;
			checkType(l,1,out a1);
			UnityEngine.AnimationCurve a2;
			checkType(l,2,out a2);
			System.Single a3;
			checkType(l,3,out a3);
			LeanAudio.printOutAudioClip(a1,ref a2,a3);
			pushValue(l,true);
			pushValue(l,a2);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_MIN_FREQEUNCY_PERIOD(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,LeanAudio.MIN_FREQEUNCY_PERIOD);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_MIN_FREQEUNCY_PERIOD(IntPtr l) {
		try {
			System.Single v;
			checkType(l,2,out v);
			LeanAudio.MIN_FREQEUNCY_PERIOD=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_PROCESSING_ITERATIONS_MAX(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,LeanAudio.PROCESSING_ITERATIONS_MAX);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_PROCESSING_ITERATIONS_MAX(IntPtr l) {
		try {
			System.Int32 v;
			checkType(l,2,out v);
			LeanAudio.PROCESSING_ITERATIONS_MAX=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_generatedWaveDistances(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,LeanAudio.generatedWaveDistances);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_generatedWaveDistances(IntPtr l) {
		try {
			System.Single[] v;
			checkArray(l,2,out v);
			LeanAudio.generatedWaveDistances=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_generatedWaveDistancesCount(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,LeanAudio.generatedWaveDistancesCount);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_generatedWaveDistancesCount(IntPtr l) {
		try {
			System.Int32 v;
			checkType(l,2,out v);
			LeanAudio.generatedWaveDistancesCount=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"LeanAudio");
		addMember(l,options_s);
		addMember(l,createAudioStream_s);
		addMember(l,createAudio_s);
		addMember(l,generateAudioFromCurve_s);
		addMember(l,play_s);
		addMember(l,playClipAt_s);
		addMember(l,printOutAudioClip_s);
		addMember(l,"MIN_FREQEUNCY_PERIOD",get_MIN_FREQEUNCY_PERIOD,set_MIN_FREQEUNCY_PERIOD,false);
		addMember(l,"PROCESSING_ITERATIONS_MAX",get_PROCESSING_ITERATIONS_MAX,set_PROCESSING_ITERATIONS_MAX,false);
		addMember(l,"generatedWaveDistances",get_generatedWaveDistances,set_generatedWaveDistances,false);
		addMember(l,"generatedWaveDistancesCount",get_generatedWaveDistancesCount,set_generatedWaveDistancesCount,false);
		createTypeMetatable(l,constructor, typeof(LeanAudio));
	}
}
