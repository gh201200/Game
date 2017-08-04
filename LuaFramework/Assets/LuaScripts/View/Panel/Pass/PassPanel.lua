 local _G,Screen,Language,GUI,ByteArray,print,Texture2D,CFG_harborProperty,CFG_buildDesc,os,Vector2
 = _G,Screen,Language,GUI,ByteArray,print,Texture2D,CFG_harborProperty,CFG_buildDesc,os,Vector2
local PackatHead,Packat_Account,GUIStyleButton,require,GUIStyleLabel,Color,Packat_Harbor,CFG_harbor = 
PackatHead,Packat_Account,GUIStyleButton,require,GUIStyleLabel,Color,Packat_Harbor,CFG_harbor
local ConstValue,CFG_buildUp,AppearEvent,EventType = ConstValue,CFG_buildUp,AppearEvent,EventType
local AssetType,math,CFG_pass,string,CFG_passProperty,SceneType,CFG_title,CFG_property,Packat_Rank = 
AssetType,math,CFG_pass,string,CFG_passProperty,SceneType,CFG_title,CFG_property,Packat_Rank
local mAssetManager = nil
local mNetManager = nil
local mPanelManager = nil
local mSceneManager = nil
local mGUIStyleManager = nil
local mMainPanel = nil
local mTavernPanel = nil
local mShopPanel = nil
local mShipyardPanel = nil
local mSystemTip = nil
local mHeroManager = nil
local mCommonlyFunc = nil
local mBuildViewPanel = nil
local mHarborManager = nil
local mLabManager = nil
local mAlert = nil
local mSelectAlert = nil
local mSetManager = nil
local mPassManager = nil
module("LuaScript.View.Panel.Pass.PassPanel") -- 血战闯关界面
mScrollPositionY = 0
mPage = 1
notAutoClose = true

local mCostTip = nil
local mCurRank = nil
local mLastRank = nil


function Init()
	mAssetManager = require "LuaScript.Control.AssetManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mLabManager = require "LuaScript.Control.Data.LabManager"
	mHarborManager = require "LuaScript.Control.Scene.HarborManager"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mGUIStyleManager = require "LuaScript.Control.GUIStyleManager"
	mMainPanel = require "LuaScript.View.Panel.Main.Main"
	mTavernPanel = require "LuaScript.View.Panel.Harbor.TavernPanel"
	mShopPanel = require "LuaScript.View.Panel.Harbor.ShopPanel"
	mShipyardPanel = require "LuaScript.View.Panel.Harbor.ShipyardPanel"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mBuildViewPanel = require "LuaScript.View.Panel.Harbor.BuildViewPanel"
	mSetManager = require "LuaScript.Control.System.SetManager"
	mPassManager = require "LuaScript.Control.Data.PassManager"
	mAlert = require "LuaScript.View.Alert.Alert"
	mSelectAlert = require "LuaScript.View.Alert.SelectAlert"
	
	mNetManager.AddListen(PackatHead.RANK, Packat_Rank.SEND_TOWER_RANK_LIST, SEND_TOWER_RANK_LIST)
	mNetManager.AddListen(PackatHead.RANK, Packat_Rank.SEND_TOWER_LASTRANK_LIST, SEND_TOWER_LASTRANK_LIST)
	
	IsInit = true
end

function SEND_TOWER_RANK_LIST(cs_ByteArray)
	-- print("SEND_TOWER_RANK_LIST")
	mCurRank = {}
	
	for i=1,10 do
		local tower = ByteArray.ReadByte(cs_ByteArray)
		local star = ByteArray.ReadShort(cs_ByteArray)
		local name = ByteArray.ReadUTF(cs_ByteArray, 40)
		
		mCurRank[i] = {name=name,star=star,tower=tower}
		-- print(mCurRank[i])
	end
	-- print(mCurRank)
end

function SEND_TOWER_LASTRANK_LIST(cs_ByteArray)
	-- print("SEND_TOWER_LASTRANK_LIST")
	mLastRank = {}
	
	for i=1,10 do
		local tower = ByteArray.ReadByte(cs_ByteArray)
		local star = ByteArray.ReadShort(cs_ByteArray)
		local name = ByteArray.ReadUTF(cs_ByteArray, 40)
		
		mLastRank[i] = {name=name,star=star,tower=tower}
		-- print(mLastRank[i])
	end
	-- print(mLastRank)
end

function Display()
	mCurRank = nil
	mLastRank = nil
	-- mScrollPositionY = 0
	mCostTip = mSetManager.GetCostTip()
	mSceneManager.SetMouseEvent(false)
end

function Hide()
	mSceneManager.SetMouseEvent(true)
	mScrollPositionY = 0
	mPage = 1
end

function OnGUI()
	if not IsInit then
		return
	end
	
	local hero = mHeroManager.GetHero()
	if hero.SceneType == SceneType.Battle then
		return
	end
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg9_1")
	GUI.DrawTexture(0,0,1136,640,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/pass")
	GUI.DrawTexture(82,119,977,508,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Button/btn12_3")
	GUI.DrawTexture(23.75,37.5,53,58,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Button/btn12_3")
	GUI.DrawTexture(519.2,36.8,526.8,58,image, 0, 0, 1, 1, 15, 15, 0, 0)
	
	if mPage == 1 then
		GUI.Button(88.35,38.3,134,58, "无尽之海", GUIStyleButton.PagBtn_2)
	elseif GUI.Button(88.35,38.3,134,58, "无尽之海", GUIStyleButton.PagBtn_1) then
		mPage = 1
	end
	
	if mPage == 2  then
		GUI.Button(232.95,38.3,134,58, "当前排行", GUIStyleButton.PagBtn_2)
	elseif GUI.Button(232.95,38.3,134,58, "当前排行", GUIStyleButton.PagBtn_1) then
		mCurRank = nil
		mPage = 2
		mScrollPositionY = 0
	end
	
	if mPage == 3  then
		GUI.Button(377,38.3,134,58, "昨日排行", GUIStyleButton.PagBtn_2)
	elseif GUI.Button(377,38.3,134,58, "昨日排行", GUIStyleButton.PagBtn_1) then
		mPage = 3
		mScrollPositionY = 0
	end
	
	-- GUI.Label(525.5,48,84.2,30,"血战", GUIStyleLabel.Center_40_Yellowish_Art, Color.Black)
	if mPage == 1 then
		local data = mPassManager.GetData()
		if data.type == 0 then
			DrawBattle(data)
		else
			DrawSelect(data)
		end
	elseif mPage == 2 then
		DrawCurrentRank()
	elseif mPage == 3 then
		DrawLastRank()
	end
	
	if GUI.Button(1060.5,37.5,53,58,nil, GUIStyleButton.CloseBtn_2) then
		mPanelManager.Show(mMainPanel)
		mPanelManager.Hide(OnGUI)
	end
end

function DrawBattle(data)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
	GUI.DrawTexture(108,138,920,66,image)
	GUI.Label(147,158,82.7,30,"第", GUIStyleLabel.Left_25_White, Color.Black)
	GUI.Label(164,150,82.7,30,data.curTower, GUIStyleLabel.Center_40_Naturals, Color.Black)
	GUI.Label(238,158,82.7,30,"关", GUIStyleLabel.Left_25_White, Color.Black)
	
	local str = "得星:" .. mCommonlyFunc.BeginColor(Color.NaturalsStr)
	str = str .. data.totalStar
	str = str .. mCommonlyFunc.EndColor()
	GUI.Label(330,158,82.7,30,str, GUIStyleLabel.Right_25_White, Color.Black)
	
	local str = "剩余:" .. mCommonlyFunc.BeginColor(Color.NaturalsStr)
	str = str .. data.leftStar
	str = str .. mCommonlyFunc.EndColor()
	GUI.Label(528,158,82.7,30,str, GUIStyleLabel.Right_25_White, Color.Black)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/star_1")
	GUI.DrawTexture(425,147,40,40,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/star_1")
	GUI.DrawTexture(625,147,40,40,image)
	
	local cd = data.coolTime - os.oldTime + data.updateTime
	if cd > 0 then
		local str = "战斗冷却时间: " .. mCommonlyFunc.GetFormatTime(cd)
		GUI.Label(715,158,82.7,30,str,GUIStyleLabel.Left_25_White, Color.Black)
	else
		local str = "再过" .. mCommonlyFunc.BeginColor(Color.NaturalsStr)
		str = str .. 5-(data.curTower-1)%5
		str = str .. mCommonlyFunc.EndColor()
		str = str .. "关结算奖励"
		GUI.Label(715,158,82.7,30,str,GUIStyleLabel.Left_25_White, Color.Black)
	end
	
	local cfg_pass = CFG_pass[data.curTower.."_3"]
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot_4")
	GUI.DrawTexture(172,217,118,118,image)
	if cfg_pass then
		local image = mAssetManager.GetAsset("Texture/Character/Header/"..cfg_pass.resId)
		GUI.DrawTexture(180,225,90,90,image)
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/pass_1")
		GUI.DrawTexture(102,207,930,111,image)
		local str = string.format("最高评价: %d星\n总战斗力: %d",data.curStar3,cfg_pass.power)
		GUI.Label(318,234,82,30,str,GUIStyleLabel.Left_25_LightGreen_Art, Color.Black)
	else
		local image = mAssetManager.GetAsset("Texture/Character/Header/6")
		GUI.DrawTexture(180,225,90,90,image)
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/pass_1")
		GUI.DrawTexture(102,207,930,111,image)
		local str = string.format("最高评价: %d星\n本关暂未开发",data.curStar3)
		GUI.Label(318,234,82,30,str,GUIStyleLabel.Left_25_LightGreen_Art, Color.Black)
	end
	
	
	local cfg_pass = CFG_pass[data.curTower.."_2"]
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot_3")
	GUI.DrawTexture(172,322,118,118,image)
	if cfg_pass then
		local image = mAssetManager.GetAsset("Texture/Character/Header/"..cfg_pass.resId)
		GUI.DrawTexture(180,330,90,90,image)
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/pass_2")
		GUI.DrawTexture(102,319,930,111,image)
		local str = string.format("最高评价: %d星\n总战斗力: %d",data.curStar2,cfg_pass.power)
		GUI.Label(318,351,82,30,str,GUIStyleLabel.Left_25_LightGreen_Art, Color.Black)
	else
		local image = mAssetManager.GetAsset("Texture/Character/Header/6")
		GUI.DrawTexture(180,330,90,90,image)
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/pass_2")
		GUI.DrawTexture(102,319,930,111,image)
		local str = string.format("最高评价: %d星\n本关暂未开发",data.curStar2)
		GUI.Label(318,351,82,30,str,GUIStyleLabel.Left_25_LightGreen_Art, Color.Black)
	end
	
	local cfg_pass = CFG_pass[data.curTower.."_1"]
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot_2")
	GUI.DrawTexture(172,435,118,118,image)
	if cfg_pass then
		local image = mAssetManager.GetAsset("Texture/Character/Header/"..cfg_pass.resId)
		GUI.DrawTexture(180,443,90,90,image)
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/pass_3")
		GUI.DrawTexture(102,432,930,111,image)
		local str = string.format("最高记录: %d星\n总战斗力: %d",data.curStar1,cfg_pass.power)
		GUI.Label(318,505+5-47,82,30,str,GUIStyleLabel.Left_25_LightGreen_Art, Color.Black)
	else
		local image = mAssetManager.GetAsset("Texture/Character/Header/6")
		GUI.DrawTexture(180,443,90,90,image)
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/pass_3")
		GUI.DrawTexture(102,432,930,111,image)
		local str = string.format("最高记录: %d星\n本关暂未开发",data.curStar1)
		GUI.Label(318,505+5-47,82,30,str,GUIStyleLabel.Left_25_LightGreen_Art, Color.Black)
	end
	
	local oldEnabled = GUI.GetEnabled()
	if not cfg_pass then
		GUI.SetEnabled(false)
	end
	--绘制三个进入战斗的按钮
	if GUI.Button(798,204,118,110,nil,GUIStyleButton.PassBtn_3) then
		RequestBattle(data.curTower, 3, 1)
	end
	GUI.FrameAnimation(798-70,204-73,256,256,'DieFightButton',10,0.1) -- 动画
	if GUI.Button(798,316,118,110,nil,GUIStyleButton.PassBtn_1) then
		RequestBattle(data.curTower, 2, 1)
	end
	if GUI.Button(798,428,118,110,nil,GUIStyleButton.PassBtn_2) then
		RequestBattle(data.curTower, 1, 1)
	end
	
	if data.curStar3 == 3 and GUI.Button(920,232,87,72,nil,GUIStyleButton.PassBtn_4) then
		RequestBattle(data.curTower, 3, 2)
	end
	if data.curStar2 == 3 and  GUI.Button(920,345,87,72,nil,GUIStyleButton.PassBtn_4) then
		RequestBattle(data.curTower, 2, 2)
	end
	if data.curStar1 == 3 and  GUI.Button(920,457,87,72,nil,GUIStyleButton.PassBtn_4) then
		RequestBattle(data.curTower, 1, 2)
	end
	if not cfg_pass then
		GUI.SetEnabled(oldEnabled)
	end
	-- if GUI.Button(916,136,111,73,nil,GUIStyleButton.PassBtn_5) then
		-- mSystemTip.ShowTip("该功能")
	-- end
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
	GUI.DrawTexture(108,546,920,56,image)
	
	GUI.Label(218,558,82,30,"当前加成:",GUIStyleLabel.Left_25_White, Color.Black)
	GUI.Label(376,558,82,30,"血量: +"..data.totalHp,GUIStyleLabel.Left_25_Red_Art, Color.Black)
	GUI.Label(550,558,82,30,"攻击: +"..data.totalAtt,GUIStyleLabel.Left_25_Purple_Art, Color.Black)
	GUI.Label(726,558,82,30,"防御: +"..data.totalDef,GUIStyleLabel.Left_25_Lime_Art, Color.Black)
end

function RequestBattle(id, type, index)
	local hero = mHeroManager.GetHero()
	if hero.SceneType ~= SceneType.Harbor then
		mAlert.Show("在港口内才能挑战,是否返回回港口？",
				function()
					mHeroManager.GotoHarbor()
					mPanelManager.Show(mMainPanel)
					mPanelManager.Hide(OnGUI)
				end)
		
		return
	end
	function OkFunc()
		if index == 1 then
			mPassManager.RequestBattle(id, type)
		else
			mPassManager.RequestFastBattle(id, type)
		end
	end
	
	local data = mPassManager.GetData()
	local cd = data.coolTime - os.oldTime + data.updateTime
	if cd > 0 then
		if not mCommonlyFunc.HaveGold(10) then
			return
		end
		if mCostTip then
			function okFunc(showTip)
				OkFunc()
				mCostTip = not showTip
			end
			mSelectAlert.Show("是否花费10元宝清除冷却时间？", okFunc)
		else
			OkFunc()
		end
	else
		OkFunc()
	end
end

function DrawSelect(data)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
	GUI.DrawTexture(108,138,920,66,image)
	-- GUI.Label(147,158,82.7,30,"已闯过", GUIStyleLabel.Left_25_White, Color.Black)
	-- GUI.Label(164,145,82.7,30,"999", GUIStyleLabel.Center_40_Naturals, Color.Black)
	-- GUI.Label(238,158,82.7,30,"关", GUIStyleLabel.Left_25_White, Color.Black)
	
	local str = "得星:" .. mCommonlyFunc.BeginColor(Color.NaturalsStr)
	str = str .. data.totalStar
	str = str .. mCommonlyFunc.EndColor()
	GUI.Label(230,158,82.7,30,str, GUIStyleLabel.Right_25_White, Color.Black)
	
	local str = "剩余:" .. mCommonlyFunc.BeginColor(Color.NaturalsStr)
	str = str .. data.leftStar
	str = str .. mCommonlyFunc.EndColor()
	GUI.Label(468,158,82.7,30,str, GUIStyleLabel.Right_25_White, Color.Black)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/star_1")
	GUI.DrawTexture(325,147,40,40,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/star_1")
	GUI.DrawTexture(565,147,40,40,image)
	
	GUI.Label(715,158,82.7,30,"选择一项加强属性",GUIStyleLabel.Left_25_White, Color.Black)
	
	local cfg_passProperty = CFG_passProperty[data.buffId1]
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/passProperty_"..cfg_passProperty.propertyId)
	GUI.DrawTexture(106,208,306,334,image)
	GUI.Label(221,373,82,30,"+"..cfg_passProperty.propertyValue,GUIStyleLabel.Center_30_LightYellow_Art, Color.Black)
	GUI.Label(221,410,82,30,"消耗: "..cfg_passProperty.expense.." 星",GUIStyleLabel.Center_30_LightYellow_Art, Color.Black)
	
	
	local cfg_passProperty = CFG_passProperty[data.buffId2]
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/passProperty_"..cfg_passProperty.propertyId)
	GUI.DrawTexture(416,208,306,334,image)
	GUI.Label(533,373,82,30,"+"..cfg_passProperty.propertyValue,GUIStyleLabel.Center_30_LightYellow_Art, Color.Black)
	GUI.Label(533,410,82,30,"消耗: "..cfg_passProperty.expense.." 星",GUIStyleLabel.Center_30_LightYellow_Art, Color.Black)
	
	local cfg_passProperty = CFG_passProperty[data.buffId3]
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/passProperty_"..cfg_passProperty.propertyId)
	GUI.DrawTexture(726,208,306,334,image)
	GUI.Label(841,373,82,30,"+"..cfg_passProperty.propertyValue,GUIStyleLabel.Center_30_LightYellow_Art, Color.Black)
	GUI.Label(841,410,82,30,"消耗: "..cfg_passProperty.expense.." 星",GUIStyleLabel.Center_30_LightYellow_Art, Color.Black)
	
	if GUI.Button(171,434,209,88,nil,GUIStyleButton.PassBtn_6) then
		mPassManager.RequestSelectBuff(data.buffId1)
		mPassManager.RequestSelectBuff(data.buffId1)
	end
	if GUI.Button(481,434,209,88,nil,GUIStyleButton.PassBtn_6) then
		if data.leftStar < 15 then
			mSystemTip.ShowTip("星数不够,无法提升")
			return
		end
		mPassManager.RequestSelectBuff(data.buffId2)
	end
	if GUI.Button(791,434,209,88,nil,GUIStyleButton.PassBtn_6) then
		if data.leftStar < 30 then
			mSystemTip.ShowTip("星数不够,无法提升")
			return
		end
		mPassManager.RequestSelectBuff(data.buffId3)
	end
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
	GUI.DrawTexture(108,546,920,56,image)
	
	GUI.Label(218,558,82,30,"当前加成:",GUIStyleLabel.Left_25_White, Color.Black)
	GUI.Label(376,558,82,30,"血量: +"..data.totalHp,GUIStyleLabel.Left_25_Red_Art, Color.Black)
	GUI.Label(550,558,82,30,"攻击: +"..data.totalAtt,GUIStyleLabel.Left_25_Purple_Art, Color.Black)
	GUI.Label(726,558,82,30,"防御: +"..data.totalDef,GUIStyleLabel.Left_25_Lime_Art, Color.Black)
end

function DrawCurrentRank()
	GUI.Label(150,142,82,30,"排名",GUIStyleLabel.Left_35_Earth)
	GUI.Label(291,142,82,30,"名称",GUIStyleLabel.Left_35_Earth)
	GUI.Label(478,142,82,30,"关数",GUIStyleLabel.Left_35_Earth)
	GUI.Label(635,142,82,30,"星数",GUIStyleLabel.Left_35_Earth)
	GUI.Label(813,142,82,30,"可获称号",GUIStyleLabel.Left_35_Earth)
	if not mCurRank then
		mCurRank = {}
		RequestCurRankData()
	end
	local spacing = 60
	local count = 10
	_,mScrollPositionY = GUI.BeginScrollView(99, 187, 950, 420, 0, mScrollPositionY, 0, 0, 950, spacing * count)
		for k=1,10 do
			local y = (k-1)*spacing
			DrawRanker(k, y, mCurRank[k])
		end
	GUI.EndScrollView()
end



function DrawLastRank()
	GUI.Label(150,142,82,30,"排名",GUIStyleLabel.Left_35_Earth)
	GUI.Label(291,142,82,30,"名称",GUIStyleLabel.Left_35_Earth)
	GUI.Label(478,142,82,30,"关数",GUIStyleLabel.Left_35_Earth)
	GUI.Label(635,142,82,30,"星数",GUIStyleLabel.Left_35_Earth)
	GUI.Label(848,142,82,30,"称号",GUIStyleLabel.Left_35_Earth)
	
	if not mLastRank then
		mLastRank = {}
		RequestLastRankData()
	end
	
	local spacing = 60
	local count = 10
	_,mScrollPositionY = GUI.BeginScrollView(99, 187, 950, 420, 0, mScrollPositionY, 0, 0, 950, spacing * count)
		for k=1,10 do
			local y = (k-1)*spacing
			DrawRanker(k, y, mLastRank[k])
		end
	GUI.EndScrollView()
end

function DrawRanker(k, y, ranker)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
	GUI.DrawTexture(9,y,920,54,image)
	if not ranker then
		return
	end
	if ranker.tower == 0 then
		return
	end
	if k == 1 then
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/th1")
		GUI.DrawTexture(80-23,y,60,54,image)
	elseif k == 2 then
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/th2")
		GUI.DrawTexture(83-23,y+1,54,53,image)
	elseif k == 3 then
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/th3")
		GUI.DrawTexture(89-23,y+5,42,47,image)
	else
		GUI.Label(64-15, y+7, 74.2, 30, k.."th", GUIStyleLabel.Center_35_Yellow, Color.Black)
	end
	
	GUI.Label(190, y+17, 74.2, 30, ranker.name, GUIStyleLabel.Center_25_Redbean_Art)
	GUI.Label(390, y+17, 50.35, 100, ranker.tower, GUIStyleLabel.Center_25_White, Color.Black)
	GUI.Label(543, y+17, 50.35, 100, ranker.star, GUIStyleLabel.Center_25_White, Color.Black)
	
	GUI.Label(760, y+17, 50.35, 100, GetTitleDest(k), GUIStyleLabel.Center_25_White_Art, Color.Black)
	
end

function GetTitleDest(k)
	local cfg_title = CFG_title[math.min(k, 4)]
	if cfg_title.desc then
		return cfg_title.desc
	end
	local color = ConstValue.QualityColorStr[cfg_title.quality]
	local desc = mCommonlyFunc.BeginColor(color)
	local cfg_property = CFG_property[cfg_title.type]
	desc = desc .. cfg_title.name .. "(" .. cfg_property.type .. "+" .. cfg_title.value .. cfg_property.sign .. ")"
	desc = desc .. mCommonlyFunc.EndColor()
	
	cfg_title.desc = desc
	
	return cfg_title.desc
end

function RequestCurRankData()
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.RANK)
	ByteArray.WriteByte(cs_ByteArray,Packat_Rank.CLIENT_REQUEST_TOWER_RANK)
	mNetManager.SendData(cs_ByteArray)
end

function RequestLastRankData()
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.RANK)
	ByteArray.WriteByte(cs_ByteArray,Packat_Rank.CLIENT_REQUEST_TOWER_LASTRANK)
	mNetManager.SendData(cs_ByteArray)
end