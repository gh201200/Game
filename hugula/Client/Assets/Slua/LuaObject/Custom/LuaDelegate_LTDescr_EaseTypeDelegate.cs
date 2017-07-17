
using System;
using System.Collections.Generic;
using LuaInterface;

namespace SLua
{
    public partial class LuaDelegation : LuaObject
    {

        static internal int checkDelegate(IntPtr l,int p,out LTDescr.EaseTypeDelegate ua) {
            int op = extractFunction(l,p);
			if(LuaDLL.lua_isnil(l,p)) {
				ua=null;
				return op;
			}
            else if (LuaDLL.lua_isuserdata(l, p)==1)
            {
                ua = (LTDescr.EaseTypeDelegate)checkObj(l, p);
                return op;
            }
            LuaDelegate ld;
            checkType(l, -1, out ld);
			LuaDLL.lua_pop(l,1);
            if(ld.d!=null)
            {
                ua = (LTDescr.EaseTypeDelegate)ld.d;
                return op;
            }
			
			l = LuaState.get(l).L;
            ua = () =>
            {
                int error = pushTry(l);

				ld.pcall(0, error);
				UnityEngine.Vector3 ret;
				checkType(l,error+1,out ret);
				LuaDLL.lua_settop(l, error-1);
				return ret;
			};
			ld.d=ua;
			return op;
		}
	}
}
