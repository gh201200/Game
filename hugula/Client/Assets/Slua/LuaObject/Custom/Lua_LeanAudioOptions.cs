using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_LeanAudioOptions : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int constructor(IntPtr l) {
		try {
			LeanAudioOptions o;
			o=new LeanAudioOptions();
			pushValue(l,true);
			pushValue(l,o);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int setFrequency(IntPtr l) {
		try {
			LeanAudioOptions self=(LeanAudioOptions)checkSelf(l);
			System.Int32 a1;
			checkType(l,2,out a1);
			var ret=self.setFrequency(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int setVibrato(IntPtr l) {
		try {
			LeanAudioOptions self=(LeanAudioOptions)checkSelf(l);
			UnityEngine.Vector3[] a1;
			checkArray(l,2,out a1);
			var ret=self.setVibrato(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int setWaveSine(IntPtr l) {
		try {
			LeanAudioOptions self=(LeanAudioOptions)checkSelf(l);
			var ret=self.setWaveSine();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int setWaveSquare(IntPtr l) {
		try {
			LeanAudioOptions self=(LeanAudioOptions)checkSelf(l);
			var ret=self.setWaveSquare();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int setWaveSawtooth(IntPtr l) {
		try {
			LeanAudioOptions self=(LeanAudioOptions)checkSelf(l);
			var ret=self.setWaveSawtooth();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int setWaveNoise(IntPtr l) {
		try {
			LeanAudioOptions self=(LeanAudioOptions)checkSelf(l);
			var ret=self.setWaveNoise();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int setWaveStyle(IntPtr l) {
		try {
			LeanAudioOptions self=(LeanAudioOptions)checkSelf(l);
			LeanAudioOptions.LeanAudioWaveStyle a1;
			checkEnum(l,2,out a1);
			var ret=self.setWaveStyle(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int setWaveNoiseScale(IntPtr l) {
		try {
			LeanAudioOptions self=(LeanAudioOptions)checkSelf(l);
			System.Single a1;
			checkType(l,2,out a1);
			var ret=self.setWaveNoiseScale(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int setWaveNoiseInfluence(IntPtr l) {
		try {
			LeanAudioOptions self=(LeanAudioOptions)checkSelf(l);
			System.Single a1;
			checkType(l,2,out a1);
			var ret=self.setWaveNoiseInfluence(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_waveStyle(IntPtr l) {
		try {
			LeanAudioOptions self=(LeanAudioOptions)checkSelf(l);
			pushValue(l,true);
			pushEnum(l,(int)self.waveStyle);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_waveStyle(IntPtr l) {
		try {
			LeanAudioOptions self=(LeanAudioOptions)checkSelf(l);
			LeanAudioOptions.LeanAudioWaveStyle v;
			checkEnum(l,2,out v);
			self.waveStyle=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_vibrato(IntPtr l) {
		try {
			LeanAudioOptions self=(LeanAudioOptions)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.vibrato);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_vibrato(IntPtr l) {
		try {
			LeanAudioOptions self=(LeanAudioOptions)checkSelf(l);
			UnityEngine.Vector3[] v;
			checkArray(l,2,out v);
			self.vibrato=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_modulation(IntPtr l) {
		try {
			LeanAudioOptions self=(LeanAudioOptions)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.modulation);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_modulation(IntPtr l) {
		try {
			LeanAudioOptions self=(LeanAudioOptions)checkSelf(l);
			UnityEngine.Vector3[] v;
			checkArray(l,2,out v);
			self.modulation=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_frequencyRate(IntPtr l) {
		try {
			LeanAudioOptions self=(LeanAudioOptions)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.frequencyRate);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_frequencyRate(IntPtr l) {
		try {
			LeanAudioOptions self=(LeanAudioOptions)checkSelf(l);
			System.Int32 v;
			checkType(l,2,out v);
			self.frequencyRate=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_waveNoiseScale(IntPtr l) {
		try {
			LeanAudioOptions self=(LeanAudioOptions)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.waveNoiseScale);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_waveNoiseScale(IntPtr l) {
		try {
			LeanAudioOptions self=(LeanAudioOptions)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.waveNoiseScale=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_waveNoiseInfluence(IntPtr l) {
		try {
			LeanAudioOptions self=(LeanAudioOptions)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.waveNoiseInfluence);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_waveNoiseInfluence(IntPtr l) {
		try {
			LeanAudioOptions self=(LeanAudioOptions)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.waveNoiseInfluence=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_useSetData(IntPtr l) {
		try {
			LeanAudioOptions self=(LeanAudioOptions)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.useSetData);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_useSetData(IntPtr l) {
		try {
			LeanAudioOptions self=(LeanAudioOptions)checkSelf(l);
			System.Boolean v;
			checkType(l,2,out v);
			self.useSetData=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_stream(IntPtr l) {
		try {
			LeanAudioOptions self=(LeanAudioOptions)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.stream);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_stream(IntPtr l) {
		try {
			LeanAudioOptions self=(LeanAudioOptions)checkSelf(l);
			LeanAudioStream v;
			checkType(l,2,out v);
			self.stream=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"LeanAudioOptions");
		addMember(l,setFrequency);
		addMember(l,setVibrato);
		addMember(l,setWaveSine);
		addMember(l,setWaveSquare);
		addMember(l,setWaveSawtooth);
		addMember(l,setWaveNoise);
		addMember(l,setWaveStyle);
		addMember(l,setWaveNoiseScale);
		addMember(l,setWaveNoiseInfluence);
		addMember(l,"waveStyle",get_waveStyle,set_waveStyle,true);
		addMember(l,"vibrato",get_vibrato,set_vibrato,true);
		addMember(l,"modulation",get_modulation,set_modulation,true);
		addMember(l,"frequencyRate",get_frequencyRate,set_frequencyRate,true);
		addMember(l,"waveNoiseScale",get_waveNoiseScale,set_waveNoiseScale,true);
		addMember(l,"waveNoiseInfluence",get_waveNoiseInfluence,set_waveNoiseInfluence,true);
		addMember(l,"useSetData",get_useSetData,set_useSetData,true);
		addMember(l,"stream",get_stream,set_stream,true);
		createTypeMetatable(l,constructor, typeof(LeanAudioOptions));
	}
}
