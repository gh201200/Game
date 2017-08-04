local GUIStyle,print,TextAnchor,Screen,ConstValue,math,AssetType,GUI,os,pairs,table,tostring,CsIsNull,UploadError,debug = 
GUIStyle,print,TextAnchor,Screen,ConstValue,math,AssetType,GUI,os,pairs,table,tostring,CsIsNull,UploadError,debug
local CsSetBackground,CsSetCextColor,CsSetClipping,CsSetAlignment,CsSetFontSize,CsSetRichText,CsSetFontStyle,CsSetWordWrap,CsSetFont,CsSetRectOffset =
CsSetBackground,CsSetCextColor,CsSetClipping,CsSetAlignment,CsSetFontSize,CsSetRichText,CsSetFontStyle,CsSetWordWrap,CsSetFont,CsSetRectOffset

local mAssetManager = require "LuaScript.Control.AssetManager"
local mTimer = require "LuaScript.Common.Timer"
module("LuaScript.Control.GUIStyleManager")

local cs_GUIStyleList = {}
local cs_OutGUIStyleList = {}
local mLastUseTime = {}

function Init()
	mTimer.SetInterval(AutoUnloadGUIStyle, 5)
end

function GetGUIStyle(style, cs_GUIStyle, outColor)
	mLastUseTime[style] = os.oldClock or os.clock()
	if not outColor then
		if cs_GUIStyleList[style] and not cs_GUIStyle then
			return cs_GUIStyleList[style]
		end
	else
		if cs_OutGUIStyleList[style] and not cs_GUIStyle then
			return cs_OutGUIStyleList[style]
		end
	end
	
	local modulus = GUI.modulus
	if style.unscale then
		modulus = 1
	end
	
	-- print(1111)
	local assetType = AssetType.GUIStyle
	local cs_GUIStyle = cs_GUIStyle or GUIStyle.Init()
	local refreshFunc = function()
		-- print("refreshFunc")
		GetGUIStyle(style, cs_GUIStyle, outColor)
	end
	
	if style.normal then
		local normal = cs_GUIStyle.normal
		if style.normal.background then
			local asset = mAssetManager.GetAsset(style.normal.background, assetType, refreshFunc)
			if CsSetBackground then
				CsSetBackground(normal, asset)
			else
				normal.background = asset
			end
		end
		if style.normal.textColor then
			-- if CsSetCextColor then
				-- CsSetCextColor(normal, outColor or style.normal.textColor)
			-- else
				normal.textColor = outColor or style.normal.textColor
			-- end
		end
	end
	if style.active then
		local active = cs_GUIStyle.active
		if style.active.background then
			local asset = mAssetManager.GetAsset(style.active.background, assetType, refreshFunc)
			if CsSetBackground then
				CsSetBackground(active, asset)
			else
				active.background = asset
			end
		end
		if style.active.textColor then
			-- if CsSetCextColor then
				-- CsSetCextColor(active, outColor or style.active.textColor)
			-- else
				active.textColor = outColor or style.active.textColor
			-- end
		end
	end
	if style.clipping then
		if CsSetClipping then
			CsSetClipping(cs_GUIStyle, style.clipping)
		else
			cs_GUIStyle.clipping = style.clipping
		end
	end
	if style.alignment then
		if CsSetAlignment then
			CsSetAlignment(cs_GUIStyle, style.alignment)
		else
			cs_GUIStyle.alignment = style.alignment
		end
	end
	if style.fontSize then
		if CsSetFontSize then
			CsSetFontSize(cs_GUIStyle, style.fontSize * modulus)
		else
			cs_GUIStyle.fontSize = style.fontSize * modulus
		end
	end
	if style.richText then
		if CsSetRichText then
			CsSetRichText(cs_GUIStyle, style.richText)
		else
			cs_GUIStyle.richText = style.richText
		end
	end
	
	if style.fontStyle then
		if CsSetFontStyle then
			CsSetFontStyle(cs_GUIStyle, style.fontStyle)
		else
			cs_GUIStyle.fontStyle = style.fontStyle
		end
	end
	if style.padding and style.fontSize then
		if CsSetRectOffset then
			CsSetRectOffset(cs_GUIStyle.padding,
				math.floor((style.padding.top or 0) * modulus + 1.15/2*(style.fontSize*modulus - cs_GUIStyle.fontSize)),
				math.floor((style.padding.bottom or 0) * modulus + 1.15/2*(style.fontSize*modulus - cs_GUIStyle.fontSize)),
				math.floor((style.padding.left or 0) * modulus),
				math.floor((style.padding.right or 0) * modulus))
		else
			cs_GUIStyle.padding.top = math.floor((style.padding.top or 0) * modulus + 1.15/2*(style.fontSize*modulus - cs_GUIStyle.fontSize))
			cs_GUIStyle.padding.bottom = math.floor((style.padding.bottom or 0) * modulus + 1.15/2*(style.fontSize*modulus - cs_GUIStyle.fontSize))
			cs_GUIStyle.padding.left = math.floor((style.padding.left or 0) * modulus)
			cs_GUIStyle.padding.right = math.floor((style.padding.right or 0) * modulus)
		end
		
	elseif style.padding then
		if CsSetRectOffset then
			CsSetRectOffset(cs_GUIStyle.padding,
				math.floor((style.padding.top or 0) * modulus),
				math.floor((style.padding.bottom or 0) * modulus),
				math.floor((style.padding.left or 0) * modulus),
				math.floor((style.padding.right or 0) * modulus))
		else
			cs_GUIStyle.padding.top = math.floor((style.padding.top or 0) * modulus)
			cs_GUIStyle.padding.bottom = math.floor((style.padding.bottom or 0) * modulus)
			cs_GUIStyle.padding.left = math.floor((style.padding.left or 0) * modulus)
			cs_GUIStyle.padding.right = math.floor((style.padding.right or 0) * modulus)
		end
	end
	if style.border then
		if CsSetRectOffset then
			CsSetRectOffset(cs_GUIStyle.border,
				style.border.top or 0,
				style.border.bottom or 0,
				math.floor((style.border.left or 0) * modulus),
				math.floor((style.border.right or 0) * modulus))
		else
			cs_GUIStyle.border.top = style.border.top or 0
			cs_GUIStyle.border.bottom = style.border.bottom or 0
			cs_GUIStyle.border.left = math.floor((style.border.left or 0) * modulus)
			cs_GUIStyle.border.right = math.floor((style.border.right or 0) * modulus)
		end
	end
	if style.margin then
		if CsSetRectOffset then
			CsSetRectOffset(cs_GUIStyle.margin,
			style.margin.top or 0,
			style.margin.bottom or 0,
			math.floor((style.margin.left or 0) * modulus),
			math.floor((style.margin.right or 0) * modulus))
		else
			cs_GUIStyle.margin.top = style.margin.top or 0
			cs_GUIStyle.margin.bottom = style.margin.bottom or 0
			cs_GUIStyle.margin.left = math.floor((style.margin.left or 0) * modulus)
			cs_GUIStyle.margin.right = math.floor((style.margin.right or 0) * modulus)
		end
	end
	if style.wordWrap then
		if CsSetWordWrap then
			CsSetWordWrap(cs_GUIStyle, style.wordWrap)
		else
			cs_GUIStyle.wordWrap = style.wordWrap
		end
	end
	local font = style.font or ConstValue.SimsunFont
	local asset = mAssetManager.GetAsset(font, AssetType.Forever, refreshFunc)
	if CsSetFont then
		CsSetFont(cs_GUIStyle, asset)
	else
		cs_GUIStyle.font = asset
	end
	if not outColor then
		cs_GUIStyleList[style] = cs_GUIStyle
	else
		cs_OutGUIStyleList[style] = cs_GUIStyle
	end
	return cs_GUIStyle
end

function UnloadGUIStyle(style)
	if style.normal and style.normal.background then
		mAssetManager.UnloadAsset(style.normal.background)
	end
	
	if style.active and style.active.background then
		mAssetManager.UnloadAsset(style.active.background)
	end
	
	cs_GUIStyleList[style] = nil
	cs_OutGUIStyleList[style] = nil
end

function AutoUnloadGUIStyle(style)
	-- print("AutoUnloadGUIStyle")
	-- local t = os.clock()
	local unloadGUIStyleList = {}
	for style,_ in pairs(cs_GUIStyleList) do
		if not style.Forever and os.oldClock - mLastUseTime[style] > 5 then
			table.insert(unloadGUIStyleList, style)
		end
	end
	
	for _,style in pairs(unloadGUIStyleList) do
		UnloadGUIStyle(style)
	end
	
	-- print(os.clock() - t)
	-- print(unloadGUIStyleList)
end