local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,_G,getfenv,GUIStyleButton,ConstValue,GUIStyleLabel = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,_G,getfenv,GUIStyleButton,ConstValue,GUIStyleLabel
local mAssetManager = nil
local mGUIStyleManager = nil
local mPanelManager = nil
local mSceneManager = nil
local mPromptAlert = nil
local mCommonlyFunc = nil
local ConstValue = ConstValue
local mHeroManager = nil --角色信息
local CFG_vipLevel = CFG_vipLevel
local CFG_vipProperty = CFG_vipProperty
local mScrollPositionX = nil
local os = os
module("LuaScript.View.Panel.VIPprivilege.VIPprivilege")
panelType = ConstValue.AlertPanel --面板属性为弹出框，屏蔽其他UI的响应
local panelType = ConstValue.AlertPanel --面板属性为弹出框，屏蔽其他UI的响应
local FirstRechangePanel = require "LuaScript.View.Panel.FirstRechange.FirstRechange" --首冲
local mRechargePanel = require "LuaScript.View.Panel.Recharge.RechargePanel" --充值界面

local hero = nil


function Init()
	mAssetManager = require "LuaScript.Control.AssetManager"
	mGUIStyleManager = require "LuaScript.Control.GUIStyleManager"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mPromptAlert = require "LuaScript.View.Alert.PromptAlert"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mScrollPositionX = 0
	IsInit = true
end

function Display()
	mMouseEventState = mSceneManager.GetMouseEventState()
	mSceneManager.SetMouseEvent(false) --关闭海面相应
	
	hero = mHeroManager.GetHero()
	if  hero.vipLevel > 4 then
       mScrollPositionX = (hero.vipLevel * 112) - 336
 	elseif  hero.vipLevel >= 11 then
	   mScrollPositionX	= 730 
	end
end
 

function OnGUI()

	local hero = mHeroManager.GetHero()
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/vipPanel_1")
	GUI.DrawPackerTexture(image)

	--立即充值按钮屏蔽
	-- if GUI.Button(510, 590, 100, 40,nil,GUIStyleButton.RechangeEntry) then
		-- --切换到首冲界面-或直接前往充值
		-- mPanelManager.Show(FirstRechangePanel)
		-- mPanelManager.Hide(OnGUI)
	-- end
	
	if GUI.Button(1046, 10, 88,88, nil, GUIStyleButton.CloseBtn_4) then
		--关闭按钮
		mPanelManager.Hide(OnGUI)
		mSceneManager.SetMouseEvent(true) -- 打开海面点击
	end
	
	local vL = CFG_vipLevel
	local vP = CFG_vipProperty
	local x,y = 120,60 --距离左上角坐标
	local w,h = 112,43  --默认的每个元素大小
	local showType,content,vipIndex,ShowGuiStyle
	--绘制VIP特权表滑动窗
	mScrollPositionX = GUI.BeginScrollView(260,80,820,516, mScrollPositionX, 0, 0, 0,(w)*15, 200)
	-- print(mScrollPositionX)
	  for prerogative=1,11 do
		showType = CFG_vipProperty[prerogative].showType
		for level=1,15 do
		--VIP图标,背景板
		   if prerogative == 1 then
			local bgImage_on = mAssetManager.GetAsset("Texture/Gui/Bg/vipBg_ON")
			local bgImage_off = mAssetManager.GetAsset("Texture/Gui/Bg/vipBg_OFF")
			
			--根据当前玩家的vip等级，高亮显示的背景
		    if hero.vipLevel == level then--背景
				GUI.DrawTexture(0 + (w * (level - 1 )),0 + (h * (prerogative -1)), w-3, 501, bgImage_on )
			else
				GUI.DrawTexture(0 + (w * (level - 1 )),0 + (h * (prerogative -1)), w-3, 501, bgImage_off )
			end 
			local image = mAssetManager.GetAsset(ConstValue.vipGuiImagePath[level])
			GUI.DrawTexture(15 + 18 + (w * (level - 1 )),3 + (h * (prerogative -1)), 64, 32, image )--VIP显示
		   end
		--显示的值
		   vipIndex = level .. '_' .. prerogative
		   content = CFG_vipLevel[vipIndex].propertyValue
		   ShowGuiStyle = GUIStyleLabel.Center_20_Cyan
		--显示的类型
			if showType == 1 then
				content = '+'..content
			elseif showType == 2 then --显示对错号
				   if  content == 0 then
					   content = ''
					   ShowGuiStyle_false = GUIStyleButton.Vip_Warranty_false   
					   GUI.Label(40+(w * (level - 1 )),-3 + (h * (prerogative)),35,35,content,ShowGuiStyle_false, nil)
				   elseif content == 1 then
					   content = ''
					   ShowGuiStyle_true = GUIStyleButton.Vip_Warranty_true  
					   GUI.Label(41+(w * (level - 1 )),-2 + (h * (prerogative)),33,33,content,ShowGuiStyle_true, nil)
				   end
			elseif showType == 3 then
				content = '+'..content..'%'
			elseif showType == 4 then	   		
				content = content..'折'
			end
			content = '<color=#3c1903>'..content..'</color>'
		--最后显示的文字
		GUI.Label(0 + (w * (level - 1 )),3+ (h * (prerogative)),w,h,content,ShowGuiStyle, nil )
		end
	  end
	  
	GUI.EndScrollView()
end