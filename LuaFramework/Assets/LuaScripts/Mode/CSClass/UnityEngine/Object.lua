function Instantiate(cs_gameObject)
	-- local cs_Rect = RunStaticFunc("UnityEngine.Object", "Instantiate", cs_gameObject)
	-- return cs_Rect
	if cs_gameObject == nil then
		ErrorLog("Instantiate Error!")
		return
	end
	return CsInstantiate(cs_gameObject)
end

function Destroy(cs_gameObject)
	-- local cs_Rect = RunStaticFunc("UnityEngine.Object", "Destroy", cs_gameObject)
	-- return cs_Rect
	return CsDestroy(cs_gameObject)
end

-- StaticFuncCostList = StaticFuncCostList or {}
function RunStaticFunc(class, funcName, ...)
	-- print(class, funcName, ...)
	-- local now = os.clock()
	classList = classList or {}
	if not classList[class] then
		classList[class] = luanet.import_type(class)
	end

	local func = classList[class][funcName]
	local value = func(...)
	-- StaticFuncCostList[funcName] = StaticFuncCostList[funcName] or 0
	-- StaticFuncCostList[funcName] = StaticFuncCostList[funcName] + os.clock() - now
	return value
end

local mComponentList = {}
metatable = {__mode = 'k'}
setmetatable(mComponentList, metatable)
function GetTransform(gameObject)
	return GetComponent(gameObject, Transform.GetType())
end

function GetRenderer(gameObject)
	return GetComponent(gameObject, Renderer.GetType())
end

function GetComponent(gameObject, mType)
	if not mComponentList[gameObject] or not mComponentList[gameObject][mType] then
		mComponentList[gameObject] = mComponentList[gameObject] or {}
		mComponentList[gameObject][mType] = CsGetComponent(gameObject, mType)
	end
	return mComponentList[gameObject][mType]
end

local mChildComponentList = {}
setmetatable(mChildComponentList, metatable)
function GetComponentInChildren(gameObject, mType)
	if not mChildComponentList[gameObject] or not mChildComponentList[gameObject][mType] then
		mChildComponentList[gameObject] = mChildComponentList[gameObject] or {}
		mChildComponentList[gameObject][mType] = CsGetComponentInChildren(gameObject, mType)
	end
	return mChildComponentList[gameObject][mType]
end

local mChildList = {}
setmetatable(mChildList, metatable)
function FindChild(transform, name)
	if not mChildList[transform] or not mChildList[transform][name] then
		mChildList[transform] = mChildList[transform] or {}
		mChildList[transform][name] = CsFindChild(transform, name)
	end
	return mChildList[transform][name]
end

function GetMetatableTable()
	return mComponentList,mChildComponentList,mChildList
end

function ResetMetatableTable()
	mComponentList = {}
	setmetatable(mComponentList, metatable)
	
	mChildComponentList = {}
	setmetatable(mChildComponentList, metatable)
	
	mChildList = {}
	setmetatable(mChildList, metatable)
end