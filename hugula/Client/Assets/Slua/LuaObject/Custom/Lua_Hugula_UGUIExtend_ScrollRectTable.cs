using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Hugula_UGUIExtend_ScrollRectTable : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int GetIndex(IntPtr l) {
		try {
			Hugula.UGUIExtend.ScrollRectTable self=(Hugula.UGUIExtend.ScrollRectTable)checkSelf(l);
			Hugula.UGUIExtend.ScrollRectItem a1;
			checkType(l,2,out a1);
			var ret=self.GetIndex(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int GetDataFromIndex(IntPtr l) {
		try {
			Hugula.UGUIExtend.ScrollRectTable self=(Hugula.UGUIExtend.ScrollRectTable)checkSelf(l);
			System.Int32 a1;
			checkType(l,2,out a1);
			var ret=self.GetDataFromIndex(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int RemoveChild(IntPtr l) {
		try {
			Hugula.UGUIExtend.ScrollRectTable self=(Hugula.UGUIExtend.ScrollRectTable)checkSelf(l);
			Hugula.UGUIExtend.ScrollRectItem a1;
			checkType(l,2,out a1);
			var ret=self.RemoveChild(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int InsertData(IntPtr l) {
		try {
			Hugula.UGUIExtend.ScrollRectTable self=(Hugula.UGUIExtend.ScrollRectTable)checkSelf(l);
			System.Object a1;
			checkType(l,2,out a1);
			System.Int32 a2;
			checkType(l,3,out a2);
			var ret=self.InsertData(a1,a2);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int RemoveDataAt(IntPtr l) {
		try {
			Hugula.UGUIExtend.ScrollRectTable self=(Hugula.UGUIExtend.ScrollRectTable)checkSelf(l);
			System.Int32 a1;
			checkType(l,2,out a1);
			var ret=self.RemoveDataAt(a1);
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
			Hugula.UGUIExtend.ScrollRectTable self=(Hugula.UGUIExtend.ScrollRectTable)checkSelf(l);
			self.Clear();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int ScrollTo(IntPtr l) {
		try {
			Hugula.UGUIExtend.ScrollRectTable self=(Hugula.UGUIExtend.ScrollRectTable)checkSelf(l);
			System.Int32 a1;
			checkType(l,2,out a1);
			self.ScrollTo(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Refresh(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==2){
				Hugula.UGUIExtend.ScrollRectTable self=(Hugula.UGUIExtend.ScrollRectTable)checkSelf(l);
				Hugula.UGUIExtend.ScrollRectItem a1;
				checkType(l,2,out a1);
				self.Refresh(a1);
				pushValue(l,true);
				return 1;
			}
			else if(argc==3){
				Hugula.UGUIExtend.ScrollRectTable self=(Hugula.UGUIExtend.ScrollRectTable)checkSelf(l);
				System.Int32 a1;
				checkType(l,2,out a1);
				System.Int32 a2;
				checkType(l,3,out a2);
				self.Refresh(a1,a2);
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
	static public int get_DataInsertStr(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.UGUIExtend.ScrollRectTable.DataInsertStr);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_DataInsertStr(IntPtr l) {
		try {
			System.String v;
			checkType(l,2,out v);
			Hugula.UGUIExtend.ScrollRectTable.DataInsertStr=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_DataRemoveStr(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.UGUIExtend.ScrollRectTable.DataRemoveStr);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_DataRemoveStr(IntPtr l) {
		try {
			System.String v;
			checkType(l,2,out v);
			Hugula.UGUIExtend.ScrollRectTable.DataRemoveStr=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_direction(IntPtr l) {
		try {
			Hugula.UGUIExtend.ScrollRectTable self=(Hugula.UGUIExtend.ScrollRectTable)checkSelf(l);
			pushValue(l,true);
			pushEnum(l,(int)self.direction);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_direction(IntPtr l) {
		try {
			Hugula.UGUIExtend.ScrollRectTable self=(Hugula.UGUIExtend.ScrollRectTable)checkSelf(l);
			Hugula.UGUIExtend.ScrollRectTable.Direction v;
			checkEnum(l,2,out v);
			self.direction=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_tileItem(IntPtr l) {
		try {
			Hugula.UGUIExtend.ScrollRectTable self=(Hugula.UGUIExtend.ScrollRectTable)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.tileItem);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_tileItem(IntPtr l) {
		try {
			Hugula.UGUIExtend.ScrollRectTable self=(Hugula.UGUIExtend.ScrollRectTable)checkSelf(l);
			Hugula.UGUIExtend.ScrollRectItem v;
			checkType(l,2,out v);
			self.tileItem=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_emptyItem(IntPtr l) {
		try {
			Hugula.UGUIExtend.ScrollRectTable self=(Hugula.UGUIExtend.ScrollRectTable)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.emptyItem);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_emptyItem(IntPtr l) {
		try {
			Hugula.UGUIExtend.ScrollRectTable self=(Hugula.UGUIExtend.ScrollRectTable)checkSelf(l);
			UnityEngine.GameObject v;
			checkType(l,2,out v);
			self.emptyItem=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_onItemRender(IntPtr l) {
		try {
			Hugula.UGUIExtend.ScrollRectTable self=(Hugula.UGUIExtend.ScrollRectTable)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onItemRender);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_onItemRender(IntPtr l) {
		try {
			Hugula.UGUIExtend.ScrollRectTable self=(Hugula.UGUIExtend.ScrollRectTable)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.onItemRender=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_onItemDispose(IntPtr l) {
		try {
			Hugula.UGUIExtend.ScrollRectTable self=(Hugula.UGUIExtend.ScrollRectTable)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onItemDispose);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_onItemDispose(IntPtr l) {
		try {
			Hugula.UGUIExtend.ScrollRectTable self=(Hugula.UGUIExtend.ScrollRectTable)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.onItemDispose=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_onPreRender(IntPtr l) {
		try {
			Hugula.UGUIExtend.ScrollRectTable self=(Hugula.UGUIExtend.ScrollRectTable)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onPreRender);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_onPreRender(IntPtr l) {
		try {
			Hugula.UGUIExtend.ScrollRectTable self=(Hugula.UGUIExtend.ScrollRectTable)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.onPreRender=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_onDataRemove(IntPtr l) {
		try {
			Hugula.UGUIExtend.ScrollRectTable self=(Hugula.UGUIExtend.ScrollRectTable)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onDataRemove);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_onDataRemove(IntPtr l) {
		try {
			Hugula.UGUIExtend.ScrollRectTable self=(Hugula.UGUIExtend.ScrollRectTable)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.onDataRemove=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_onDataInsert(IntPtr l) {
		try {
			Hugula.UGUIExtend.ScrollRectTable self=(Hugula.UGUIExtend.ScrollRectTable)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onDataInsert);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_onDataInsert(IntPtr l) {
		try {
			Hugula.UGUIExtend.ScrollRectTable self=(Hugula.UGUIExtend.ScrollRectTable)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.onDataInsert=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_pageSize(IntPtr l) {
		try {
			Hugula.UGUIExtend.ScrollRectTable self=(Hugula.UGUIExtend.ScrollRectTable)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.pageSize);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_pageSize(IntPtr l) {
		try {
			Hugula.UGUIExtend.ScrollRectTable self=(Hugula.UGUIExtend.ScrollRectTable)checkSelf(l);
			System.Int32 v;
			checkType(l,2,out v);
			self.pageSize=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_renderPerFrames(IntPtr l) {
		try {
			Hugula.UGUIExtend.ScrollRectTable self=(Hugula.UGUIExtend.ScrollRectTable)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.renderPerFrames);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_renderPerFrames(IntPtr l) {
		try {
			Hugula.UGUIExtend.ScrollRectTable self=(Hugula.UGUIExtend.ScrollRectTable)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.renderPerFrames=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_columns(IntPtr l) {
		try {
			Hugula.UGUIExtend.ScrollRectTable self=(Hugula.UGUIExtend.ScrollRectTable)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.columns);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_columns(IntPtr l) {
		try {
			Hugula.UGUIExtend.ScrollRectTable self=(Hugula.UGUIExtend.ScrollRectTable)checkSelf(l);
			System.Int32 v;
			checkType(l,2,out v);
			self.columns=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_padding(IntPtr l) {
		try {
			Hugula.UGUIExtend.ScrollRectTable self=(Hugula.UGUIExtend.ScrollRectTable)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.padding);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_padding(IntPtr l) {
		try {
			Hugula.UGUIExtend.ScrollRectTable self=(Hugula.UGUIExtend.ScrollRectTable)checkSelf(l);
			UnityEngine.Vector2 v;
			checkType(l,2,out v);
			self.padding=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_tileSize(IntPtr l) {
		try {
			Hugula.UGUIExtend.ScrollRectTable self=(Hugula.UGUIExtend.ScrollRectTable)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.tileSize);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_tileSize(IntPtr l) {
		try {
			Hugula.UGUIExtend.ScrollRectTable self=(Hugula.UGUIExtend.ScrollRectTable)checkSelf(l);
			UnityEngine.Vector3 v;
			checkType(l,2,out v);
			self.tileSize=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_recordCount(IntPtr l) {
		try {
			Hugula.UGUIExtend.ScrollRectTable self=(Hugula.UGUIExtend.ScrollRectTable)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.recordCount);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_data(IntPtr l) {
		try {
			Hugula.UGUIExtend.ScrollRectTable self=(Hugula.UGUIExtend.ScrollRectTable)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.data);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_data(IntPtr l) {
		try {
			Hugula.UGUIExtend.ScrollRectTable self=(Hugula.UGUIExtend.ScrollRectTable)checkSelf(l);
			SLua.LuaTable v;
			checkType(l,2,out v);
			self.data=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_headIndex(IntPtr l) {
		try {
			Hugula.UGUIExtend.ScrollRectTable self=(Hugula.UGUIExtend.ScrollRectTable)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.headIndex);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_currFirstIndex(IntPtr l) {
		try {
			Hugula.UGUIExtend.ScrollRectTable self=(Hugula.UGUIExtend.ScrollRectTable)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.currFirstIndex);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_itemRect(IntPtr l) {
		try {
			Hugula.UGUIExtend.ScrollRectTable self=(Hugula.UGUIExtend.ScrollRectTable)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.itemRect);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Hugula.UGUIExtend.ScrollRectTable");
		addMember(l,GetIndex);
		addMember(l,GetDataFromIndex);
		addMember(l,RemoveChild);
		addMember(l,InsertData);
		addMember(l,RemoveDataAt);
		addMember(l,Clear);
		addMember(l,ScrollTo);
		addMember(l,Refresh);
		addMember(l,"DataInsertStr",get_DataInsertStr,set_DataInsertStr,false);
		addMember(l,"DataRemoveStr",get_DataRemoveStr,set_DataRemoveStr,false);
		addMember(l,"direction",get_direction,set_direction,true);
		addMember(l,"tileItem",get_tileItem,set_tileItem,true);
		addMember(l,"emptyItem",get_emptyItem,set_emptyItem,true);
		addMember(l,"onItemRender",get_onItemRender,set_onItemRender,true);
		addMember(l,"onItemDispose",get_onItemDispose,set_onItemDispose,true);
		addMember(l,"onPreRender",get_onPreRender,set_onPreRender,true);
		addMember(l,"onDataRemove",get_onDataRemove,set_onDataRemove,true);
		addMember(l,"onDataInsert",get_onDataInsert,set_onDataInsert,true);
		addMember(l,"pageSize",get_pageSize,set_pageSize,true);
		addMember(l,"renderPerFrames",get_renderPerFrames,set_renderPerFrames,true);
		addMember(l,"columns",get_columns,set_columns,true);
		addMember(l,"padding",get_padding,set_padding,true);
		addMember(l,"tileSize",get_tileSize,set_tileSize,true);
		addMember(l,"recordCount",get_recordCount,null,true);
		addMember(l,"data",get_data,set_data,true);
		addMember(l,"headIndex",get_headIndex,null,true);
		addMember(l,"currFirstIndex",get_currFirstIndex,null,true);
		addMember(l,"itemRect",get_itemRect,null,true);
		createTypeMetatable(l,null, typeof(Hugula.UGUIExtend.ScrollRectTable),typeof(UnityEngine.MonoBehaviour));
	}
}
