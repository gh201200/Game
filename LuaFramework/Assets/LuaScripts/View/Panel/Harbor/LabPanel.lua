local _G,Screen,Language,GUI,ByteArray,print,Texture2D,Vector2,pairs,CFG_buildDesc,os,ConstValue = 
_G,Screen,Language,GUI,ByteArray,print,Texture2D,Vector2,pairs,CFG_buildDesc,os,ConstValue
local PackatHead,Packat_Account,GUIStyleButton,require,GUIStyleLabel,Color,Packat_Harbor,CFG_harbor,CFG_lab = 
PackatHead,Packat_Account,GUIStyleButton,require,GUIStyleLabel,Color,Packat_Harbor,CFG_harbor,CFG_lab
local AssetType,Packat_Lab,string = AssetType,Packat_Lab,string
local mAssetManager = nil
local mNetManager = nil
local mPanelManager = nil
local mSceneManager = nil
local mGUIStyleManager = nil
local mMainPanel = nil
local mTavernPanel = nil
local mShopPanel = nil
local mShipyardPanel = nil
local mLabViewPanel = nil
local mSystemTip = nil
local mHeroManager = nil
local mCommonlyFunc = nil
local mHarborManager = nil
local mLabManager = nil
local mAlert = nil
local mSelectAlert = nil
local mSetManager = nil
local mCostTip = nil
local mItemManager = nil
local mMainPanel = nil
module("LuaScript.View.Panel.Harbor.LabPanel") -- 研究所界面
FullWindowPanel = true
local mScrollPositionY = 0
function Init()
	mLabManager = require "LuaScript.Control.Data.LabManager"
	mAssetManager = require "LuaScript.Control.AssetManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mHarborManager = require "LuaScript.Control.Scene.HarborManager"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mGUIStyleManager = require "LuaScript.Control.GUIStyleManager"
	mMainPanel = require "LuaScript.View.Panel.Main.Main"
	mTavernPanel = require "LuaScript.View.Panel.Harbor.TavernPanel"
	mShopPanel = require "LuaScript.View.Panel.Harbor.ShopPanel"
	mMainPanel = require "LuaScript.View.Panel.Main.Main"
	mShipyardPanel = require "LuaScript.View.Panel.Harbor.ShipyardPanel"
	mLabViewPanel = require "LuaScript.View.Panel.Harbor.LabViewPanel"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mSetManager = require "LuaScript.Control.System.SetManager"
	mAlert = require "LuaScript.View.Alert.Alert"
	mSelectAlert = require "LuaScript.View.Alert.SelectAlert"
	mItemManager = require "LuaScript.Control.Data.ItemManager"
	IsInit = true
end

function Display()
	mScrollPositionY = 0
	mCostTip = mSetManager.GetCostTip()
end

function OnGUI()
	if not IsInit then
		return
	end
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg9_1")
	GUI.DrawTexture(0,0,1136,640,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Button/btn12_3")
	GUI.DrawTexture(23.75,37.5,53,58,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Button/btn12_3")
	GUI.DrawTexture(83.5,37.5,1016.75-50,58,image, 0, 0, 1, 1, 15, 15, 0, 0)
	
	GUI.Label(525.5,48,84.2,30,"研究所", GUIStyleLabel.Center_40_Yellowish_Art, Color.Black)
	
	local hero = mHeroManager.GetHero()
	local harbor = CFG_harbor[hero.harborId]
	local harborsList = mHarborManager.GetHarborInfoList()
	
	GUI.Label(238.65,140,82.7,30,"科技", GUIStyleLabel.Left_35_Black)
	GUI.Label(418.65-12,140,82.7,30,"等级", GUIStyleLabel.Left_35_Black)
	GUI.Label(576.65-47,140,82.7,30,"花费", GUIStyleLabel.Left_35_Black)
	GUI.Label(704.1-17-15,140,160.95,30,"升级时间", GUIStyleLabel.Left_35_Black)
	GUI.Label(887.65-17,140,82.7,30,"操作", GUIStyleLabel.Left_35_Black)
	
	local spacing = 145
	_,mScrollPositionY = GUI.BeginScrollView(154, 185.8, 900, 421.95, 0, mScrollPositionY, 0, 0, 850, spacing * 14)
		for labId=1,14,1 do
			local y = (labId-1)*spacing
			local showY = y - mScrollPositionY / GUI.modulus
			if showY > -spacing  and showY < spacing*3 then
				DrawLab(labId, y)
			end
		end
	GUI.EndScrollView()
	
	local image = mAssetManager.GetAsset("Texture/Gui/Button/btn19_1")
	GUI.DrawTexture(537,605,59,16,image)
	
	if GUI.Button(1060.5,37.5,53,58,nil, GUIStyleButton.CloseBtn_2) then
		mPanelManager.Show(mMainPanel)
		mPanelManager.Hide(OnGUI)
	end
end

function DrawLab(labId, y)
	local level = 0
	local labList = mLabManager.GetLabList()
	if labList[labId] then
		level = labList[labId].level
	end
	local key = labId .. "_" .. level
	local nextKey = labId .. "_" .. level+1
	local lab = CFG_lab[key]
	local nextLab = CFG_lab[nextKey]
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
	GUI.DrawTexture(0,y,835,130.4,image)
	local image = mAssetManager.GetAsset("Texture/Icon/lab/"..lab.icon, AssetType.Icon)
	if GUI.TextureButton(22, 22+y, 85, 85, image) then
		mLabViewPanel.SetData(labId, level)
		mPanelManager.Show(mLabViewPanel)
	end
	
	-- local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg10_1")
	-- GUI.DrawTexture(18,y+30.55,84,84,image)
	
	GUI.Label(110, y+44.2, 74.2, 30, lab.name, GUIStyleLabel.Left_35_Redbean_Art)
	GUI.Label(280, y+54.2, 16.2, 30, level, GUIStyleLabel.Center_25_Black)
	
	if nextLab and level < ConstValue.LabMaxLevel then
		local cost = nextLab.cost
		local cd = mCommonlyFunc.GetLabCd(nextLab.cd)
		local costStr = mCommonlyFunc.GetShortNumber(cost)
		local cdStr = mCommonlyFunc.GetChnTime(cd)
		GUI.Label(418-33, y+54.2, 52.2, 30, costStr, GUIStyleLabel.Center_25_Black)
		GUI.Label(548-15, y+54.2, 112.2, 30, cdStr, GUIStyleLabel.Center_25_Black)
	end
	
	local labinfo = labList[labId]
	if not mHarborManager.HarborIsMy() then
		GUI.Label(692,y+55,130.55,64.8,"不属于本势力", GUIStyleLabel.Center_25_Gray_Art)
	elseif labinfo and labinfo.cd and labinfo.cd > 0 then
		local cd = labinfo.cd + labinfo.updateTime - os.oldClock
		local csStr = mCommonlyFunc.GetFormatTime(cd)
		GUI.Label(707.9,y+33,104.2,45,csStr, GUIStyleLabel.Center_25_Red, Color.Black)
		local cfg_harbor = CFG_harbor[labinfo.harborId]
		GUI.Label(707.9,y+10,104.2,45,cfg_harbor.name, GUIStyleLabel.Center_20_Black)
		if GUI.Button(692,y+58,130.55,64.8,Language[140], GUIStyleButton.ShortOrangeArtBtn) then
			local money = mCommonlyFunc.CdToMoney(cd)
			function OkFunc(showTip)
				if not mCommonlyFunc.HaveGold(money) then
					return
				end
				local hero = mHeroManager.GetHero()
				mLabManager.RequestSpeed(labinfo.harborId)
				mCostTip = not showTip
			end
			if mCostTip then
				mSelectAlert.Show("是否花费"..money.."元宝,快速完成？", OkFunc)
			else
				if not mCommonlyFunc.HaveGold(money) then
					return
				end
				local hero = mHeroManager.GetHero()
				mLabManager.RequestSpeed(labinfo.harborId)
			end
		end
	else
		if level >= ConstValue.LabMaxLevel then
			GUI.Label(380,y+40.2,350,64.8,"已达最高等级", GUIStyleLabel.Center_40_Lime_Art, Color.Black)
		else
			local hero = mHeroManager.GetHero()
			local harborInfo = mHarborManager.GetHarborInfo(hero.harborId)
			if harborInfo and harborInfo.masterType == 1 and nextLab.contribute > 0 then
				GUI.Label(692, y + 10, 130.55, 64.8, string.format("港口联盟\n额外消耗%d贡献",nextLab.contribute), GUIStyleLabel.Center_20_Lime, Color.Black)
				y = y + 20
			end
			if GUI.Button(692,y+38.2,130.55,64.8,Language[115], GUIStyleButton.ShortOrangeArtBtn) then
				local hero = mHeroManager.GetHero()
				local buildLevel = mHarborManager.GetBuildLevel(hero.harborId, 3)
				if buildLevel <= level then
					mSystemTip.ShowTip("研究所等级太低,无法升级该科技")
					return
				end
				
				local upLabId = mLabManager.HarborLabWork(hero.harborId)
				if upLabId then
					local cfg_lab = CFG_lab[upLabId.."_1"]
					mSystemTip.ShowTip("本研究所已在升级"..cfg_lab.name)
					return
				end
				
				if CouldUpByCard(level) then
					function okFunc()
						RequestUpByCard(labId)
					end
					
					function cancelFunc()
						RequestUp(labId, nextLab.cost)
					end
					mAlert.Show("是否使用科技升级卡,直接升级该科技?",okFunc,cancelFunc)
				else
					RequestUp(labId, nextLab.cost)
				end
				
			end
		end
	end
end


function RequestUp(labId, cost)
	if not mCommonlyFunc.HaveMoney(cost) then
		return
	end
	mLabManager.RequestUpLab(labId)
end

function RequestUpByCard(labId)
	print("RequestUpByCard", labId)
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.LAB)
	ByteArray.WriteByte(cs_ByteArray,Packat_Lab.CLIENT_SPECIAL_UP_RESEARCH)
	ByteArray.WriteInt(cs_ByteArray,labId)
	mNetManager.SendData(cs_ByteArray)
end

function CouldUpByCard(level)
	if mItemManager.GetItemCountById(193) > 0 and level < 26 then
		return true
	end
end
