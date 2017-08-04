local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton,string = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton,string
local ConstValue,CFG_EquipSuit,CFG_buildDesc,CFG_harborProperty = ConstValue,CFG_EquipSuit,CFG_buildDesc,CFG_harborProperty
local AssetType,Vector2,SailorType,CFG_UniqueSailor,CFG_item = AssetType,Vector2,SailorType,CFG_UniqueSailor,CFG_item
local ItemType,DrawItemCell,AppearEvent,CFG_soul,CFG_sailorGrade,CFG_skill = ItemType,DrawItemCell,AppearEvent,CFG_soul,CFG_sailorGrade,CFG_skill

local mAssetManager = require "LuaScript.Control.AssetManager"
local mHarborManager = require "LuaScript.Control.Scene.HarborManager"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mEquipUpPanel = nil
local mEquipSelectPanel = nil

local mSceneManager = nil
local mHeroManager = require "LuaScript.Control.Scene.HeroManager"
local mCharManager = nil
local mPanelManager = nil
local mSailorManager = require "LuaScript.Control.Data.SailorManager"
local mEquipManager = require "LuaScript.Control.Data.EquipManager"
local mSailorSelectPanel = nil
local mItemManager = nil
local mAlert = nil
local Uptime = nil
local mSelectAlert = nil
local os = os

module("LuaScript.View.Panel.Sailor.SailorViewPanel") -- 船员的详细信息界面
panelType = ConstValue.AlertPanel
local mSailor = nil
local mScrollView = 0
local mScrollPositionY = 0
local mDescY = 0
local mPage = 1
local mSkillDescHeight = 0
local mCostTip = true

function SetData(sailor, page)
	local hero = mHeroManager.GetHero()
	local cfg_sailor = CFG_UniqueSailor[sailor.index]
	mSailor = sailor
	mPage = page or 1
	mCostTip = true
	
	mScrollPositionY = 0
	mSkillDescHeight = GUI.GetTextHeight(sailor.skillFullDesc, 250, GUIStyleLabel.Left_20_White_WordWrap) -- 获取技能表高度
	mScrollView = 222 + 34 + mSkillDescHeight
	mDescY = mScrollView + 15
	mScrollView = mDescY + GUI.GetTextHeight(cfg_sailor.desc, 250, GUIStyleLabel.Left_20_Black_WordWrap) -- 滑动窗上下滑动的高度
end

function AniBlinkStartTime()
	Uptime = os.clock()
end

function Init()
	mAlert = require "LuaScript.View.Alert.Alert"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	-- mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	mSelectAlert = require "LuaScript.View.Alert.SelectAlert"
	mEquipUpPanel = require "LuaScript.View.Panel.Equip.EquipUpPanel"
	mEquipSelectPanel = require "LuaScript.View.Panel.Equip.EquipSelectPanel"
	mSailorPanel = require "LuaScript.View.Panel.Sailor.SailorPanel"
	mSailorSelectPanel = require "LuaScript.View.Panel.Sailor.SailorSelectPanel"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mSetManager = require "LuaScript.Control.System.SetManager"
	mEventManager = require "LuaScript.Control.EventManager"
	mItemManager = require "LuaScript.Control.Data.ItemManager"
	Uptime = 9999
	IsInit = true
end

function OnGUI()
	if not IsInit then
		return
	end
	local cfg_sailor = CFG_UniqueSailor[mSailor.index]
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/tabBg")
	GUI.DrawTexture(233,19,390,66,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg2_2")
	GUI.DrawTexture(190,70,795,497,image)

	if GUI.Button(901, 54, 77, 63,nil, GUIStyleButton.CloseBtn) then
		mPanelManager.Hide(OnGUI)
	end
	local hero = mHeroManager.GetHero()
	--标头选项卡 1.2.3
	if mPage == 1 then
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/sailorBg_6")
		GUI.DrawTexture(236,98+7,344,416,image)
		
		local image = mAssetManager.GetAsset("Texture/Character/Pic/"..mSailor.resId, AssetType.Pic)
		GUI.DrawTexture(265, 125+7, 286, 360, image)
		
		
		if GUI.Button(254, 37, 111, 53,"信息", GUIStyleButton.ShortOrangeBtn_4) then
			mPage = 1
		end
		
		local oldEnabled = GUI.GetEnabled()
		if mSailor.notExit then
			GUI.SetEnabled(false)
		end
		
		if GUI.Button(371, 37, 111, 53,"升级", GUIStyleButton.ShortOrangeBtn_3) then
			mPage = 2
		end
		if GUI.Button(488, 37, 111, 53,"升星", GUIStyleButton.ShortOrangeBtn_3)then
			mPage = 3
		end
		if mSailor.notExit then
			GUI.SetEnabled(oldEnabled)
		end
		
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg51_6")
		GUI.DrawTexture(604,107,309,391,image,0,0,1,1,15,15,15,15)
		--详细信息的滑动窗
		_,mScrollPositionY = GUI.BeginScrollView(626,115,300,382, 0,mScrollPositionY, 0, 0,270, mScrollView,2)
			GUI.Label(59, 0, 144.2, 25, mSailor.name , GUIStyleLabel.Center_30_Redbean)
			local infoStr = mCommonlyFunc.GetQualityStr(mSailor.quality)
			GUI.Label(60, 37, 64.2, 25, infoStr, GUIStyleLabel.Left_25_White_Art, Color.Black)
			GUI.Label(0, 42, 64.2, 25, "品质:", GUIStyleLabel.Left_20_Black)
			
			-- local infoStr = mCommonlyFunc.GetSailorStarInfo(mSailor.exLevel)
			
			GUI.Label(0, 76, 64.2, 25, "等级: ", GUIStyleLabel.Left_20_Black)
			GUI.Label(60, 76, 64.2, 25, mSailor.exLevel.."级", GUIStyleLabel.Left_20_Black)
			
			GUI.Label(150, 76, 64.2, 25, "星级: ", GUIStyleLabel.Left_20_Black)
			GUI.Label(150+60, 76, 64.2, 25, mSailor.star.."星", GUIStyleLabel.Left_20_Black)
			
			-- GUI.Label(0, 110, 64.2, 25, "来源: ", GUIStyleLabel.Left_20_Black)
			-- GUI.Label(60, 105, 64.2, 25, cfg_sailor.source, GUIStyleLabel.Left_25_Lime_Art, Color.Black)
			
			GUI.Label(0, 106, 129.2, 25, "属性: ", GUIStyleLabel.Left_20_Black) --攻击，防御，血量，贸易
			local infoStr = Language[33]..mSailor.attack
			GUI.Label(12, 132, 129.2, 25, infoStr, GUIStyleLabel.Left_20_Black)
			local infoStr = Language[34]..mSailor.defense
			GUI.Label(150, 132, 129.2, 25, infoStr, GUIStyleLabel.Left_20_Black)
			local infoStr = Language[35]..mSailor.hp
			GUI.Label(12, 162, 129.2, 25, infoStr, GUIStyleLabel.Left_20_Black)
			local infoStr = Language[36]..mSailor.business
			GUI.Label(150, 162, 129.2, 25, infoStr, GUIStyleLabel.Left_20_Black)
			
			GUI.Label(0, 192, 129, 25, "技能: ", GUIStyleLabel.Left_20_Black)
			
			GUI.Label(12, 222, 250, mSkillDescHeight , mSailor.skillFullDesc , GUIStyleLabel.Left_20_White_WordWrap) -- 技能相关信息整体放入
			
			-- GUI.Label(0, 192+34, 129, 25, "觉醒: ", GUIStyleLabel.Left_20_Black)
			-- GUI.Label(12, 222+34, 250, 250, mSailor.starSkillFullDesc, GUIStyleLabel.Left_20_White_WordWrap)
			
			GUI.Label(0, mDescY-30-34, 129, 25, "描述: ", GUIStyleLabel.Left_20_Black)
			GUI.Label(12, mDescY-34, 250, 25, cfg_sailor.desc, GUIStyleLabel.Left_20_Black_WordWrap)
		GUI.EndScrollView()
		
		local infoStr = Language[28].. mSailor.power -- 战斗力
		GUI.Label(417, 457, 124, 25, infoStr, GUIStyleLabel.Right_20_White, Color.Black)
	elseif mPage == 2 then
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg20_2")
		GUI.DrawTexture(263,113,174,67,image)
		GUI.Label(279, 126, 139, 30, mSailor.name, GUIStyleLabel.Center_25_Redbean_Art)
		
		
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot1_"..mSailor.quality)
		GUI.DrawTexture(295,179,116,116,image)
		local image = mAssetManager.GetAsset("Texture/Character/Header/"..mSailor.resId, AssetType.Icon)
		GUI.DrawTexture(304,186,100,100,image)
		GUI.Label(427, 340, 84.2, 30, "攻击："..mSailor.attack, GUIStyleLabel.Left_20_White)
		
		
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg51_6")
		GUI.DrawTexture(461,119,438,177,image)
		GUI.Label(360, 264, 43, 30, mSailor.exLevel.."级", GUIStyleLabel.Right_20_Lime, Color.Black)
		
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg40_2")
		GUI.DrawTexture(269,328,633,148,image)
		
		if GUI.Button(254, 37, 111, 53,"信息", GUIStyleButton.ShortOrangeBtn_3) then
			mPage = 1
		end
		if GUI.Button(371, 37, 111, 53,"升级", GUIStyleButton.ShortOrangeBtn_4) then
			mPage = 2
		end
		if GUI.Button(488, 37, 111, 53,"升星", GUIStyleButton.ShortOrangeBtn_3)then
			mPage = 3
		end
		
		local cfg_sailorGrade = CFG_sailorGrade[mSailor.exLevel]
		local nSailorLevelUpMoney = mHeroManager.GetSailorLevelUpMoney()
		DrawItemCell({id=28,count=cfg_sailorGrade.count},ItemType.Item, 471, 179, 116, 116)
		DrawItemCell({id=14,count=cfg_sailorGrade.money*nSailorLevelUpMoney},ItemType.Item, 595, 179, 116, 116)
		
		if GUI.Button(727, 201, 166, 77, "升级", GUIStyleButton.BlueBtn) then
			if mSailor.exLevel >= hero.level then
				mSystemTip.ShowTip("已达到最高，请先提升人物等级")
				return
			end
			
			if not mCommonlyFunc.HaveMoney(cfg_sailorGrade.money*nSailorLevelUpMoney,setCostTip,mCostTip) then
				return
			end
			
			local itemCount = mItemManager.GetItemCountById(28)
			local cfg_item = CFG_item[28]
			local needCount = cfg_sailorGrade.count-itemCount
			local gold = needCount*cfg_item.price
			if itemCount< cfg_sailorGrade.count and mCostTip then
				function okFunc(showTip)
					mCostTip = not showTip
					if not mCommonlyFunc.HaveGold(gold) then
						return
					end
					mSailorManager.RequestExLevelUp(mSailor.id, mSailor.exLevel)
					AniBlinkStartTime()
				end
				
				mSelectAlert.Show(cfg_item.name.."数量不足,是否花费"..gold.."元宝购买"..needCount.."个"..cfg_item.name.."?", okFunc)
				return
			else
				if not mCommonlyFunc.HaveGold(gold) then
					return
				end
				mSailorManager.RequestExLevelUp(mSailor.id, mSailor.exLevel)
				AniBlinkStartTime()
			end
		end
		-- local image = mAssetManager.GetAsset("Texture/Gui/Text/sailorUp")
		-- GUI.DrawTexture(781,201,76,40,image)
		
		GUI.Label(427, 340, 84.2, 30, "攻击："..mSailor.attack, GUIStyleLabel.Left_20_White)
		GUI.Label(427, 370, 84.2, 30, "防御："..mSailor.defense, GUIStyleLabel.Left_20_White)
		GUI.Label(427, 402, 84.2, 30, "血量："..mSailor.hp, GUIStyleLabel.Left_20_White)
		GUI.Label(427, 438, 84.2, 30, "贸易："..mSailor.business, GUIStyleLabel.Left_20_White)
		--突破变化时出现特效
		GUI.FrameAnimation_Once(390, 285, 256, 128,'SailorPropertiesChange',Uptime,9,0.1)	
		GUI.FrameAnimation_Once(390, 315, 256, 128,'SailorPropertiesChange',Uptime,9,0.1)	
		GUI.FrameAnimation_Once(390, 350, 256, 128,'SailorPropertiesChange',Uptime,9,0.1)	
		GUI.FrameAnimation_Once(390, 380, 256, 128,'SailorPropertiesChange',Uptime,9,0.1)	
		
		
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg12_1")
		GUI.DrawTexture(568,342,38,16,image)
		GUI.DrawTexture(568,375,38,16,image)
		GUI.DrawTexture(568,410,38,16,image)
		GUI.DrawTexture(568,442,38,16,image)
		
		local cfg_sailor = CFG_UniqueSailor[mSailor.index]
		GUI.Label(653, 340, 84.2, 30, mSailor.attack+math.floor(cfg_sailor.attack/10), GUIStyleLabel.Left_20_White)
		GUI.Label(653, 370, 84.2, 30, mSailor.defense+math.floor(cfg_sailor.defense/10), GUIStyleLabel.Left_20_White)
		GUI.Label(653, 402, 84.2, 30, mSailor.hp+math.floor(cfg_sailor.hp/10), GUIStyleLabel.Left_20_White)
		GUI.Label(653, 438, 84.2, 30, mSailor.business+math.floor(cfg_sailor.business/10), GUIStyleLabel.Left_20_White)
		
	elseif mPage == 3 then
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg20_2")
		GUI.DrawTexture(263,113,174,67,image)
		GUI.Label(279, 126, 139, 30, mSailor.name, GUIStyleLabel.Center_25_Redbean_Art)
		
		
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot1_"..mSailor.quality)
		GUI.DrawTexture(295,179,116,116,image)
		local image = mAssetManager.GetAsset("Texture/Character/Header/"..mSailor.resId, AssetType.Icon)
		GUI.DrawTexture(304,186,100,100,image)
		GUI.Label(360, 264, 43, 30, mSailor.star.."星", GUIStyleLabel.Right_20_Lime, Color.Black)
		
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg51_6")
		GUI.DrawTexture(461,119,438,177,image)
		GUI.Label(480, 132, 112, 30, "所需材料", GUIStyleLabel.Left_30_Redbean)
		
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg40_2")
		GUI.DrawTexture(269,328,633,148,image)
		
		
		if GUI.Button(254, 37, 111, 53,"信息", GUIStyleButton.ShortOrangeBtn_3) then
			mPage = 1
		end
		if GUI.Button(371, 37, 111, 53,"升级", GUIStyleButton.ShortOrangeBtn_3) then
			mPage = 2
		end
		if GUI.Button(488, 37, 111, 53,"升星", GUIStyleButton.ShortOrangeBtn_4)then
			mPage = 3
		end
		
		local nextStar = mSailor.star+1
		local cfg_sailor = CFG_UniqueSailor[mSailor.index]
		local itemCount = nextStar*mSailor.quality*10
		local money = nextStar*100000
		if mSailor.type == SailorType.Hero then
			itemCount = nextStar*math.min(nextStar,4)*10
		end
		DrawItemCell({id=cfg_sailor.itemId,count=itemCount},ItemType.Item, 471, 179, 116, 116)
		DrawItemCell({id=14,count=money},ItemType.Item, 595, 179, 116, 116)
		
		GUI.Label(322, 358, 112, 30, "升星激活：", GUIStyleLabel.Left_30_Yellow2_Art)
		
	
		local cfg_skill = CFG_skill[cfg_sailor["starSkillId"..nextStar]]
		local content = string.format(cfg_skill.skillDesc,nextStar)
		GUI.Label(324, 410, 112, 30, content , GUIStyleLabel.Left_25_Lime_Art)
		
		--修改逻辑，判断应该以下一星来对比当前等级
		if GUI.Button(727, 201, 166, 77, "升星", GUIStyleButton.BlueBtn) then
			if (mSailor.star+1)*10 > mSailor.exLevel then
				mSystemTip.ShowTip("船员" .. nextStar*10 .. "级后才能升星")
				return
			end
			if mItemManager.GetItemCountById(cfg_sailor.itemId) < itemCount then
				mSystemTip.ShowTip(CFG_item[cfg_sailor.itemId].name.."数量不足")
				return
			end
			if not mCommonlyFunc.HaveMoney(money,setCostTip,mCostTip) then
				return
			end
			mSailorManager.RequestStarUp(mSailor.id)
		end
	end

end

function setCostTip(showTip)
	mCostTip = not showTip
end
