local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Packat_Player,PackatHead = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Packat_Player,PackatHead
local GUIStyleButton,ConstValue,CFG_role,CopyTable = GUIStyleButton,ConstValue,CFG_role,CopyTable
local AssetType,CharacterType,CharacterTypeStr,CFG_Enemy,tostring,debug,UploadError = 
AssetType,CharacterType,CharacterTypeStr,CFG_Enemy,tostring,debug,UploadError
local mAssetManager = require "LuaScript.Control.AssetManager"
local mHarborManager = require "LuaScript.Control.Scene.HarborManager"
local mSailorPanel = require "LuaScript.View.Panel.Sailor.SailorPanel"
local mPanelManager = require "LuaScript.Control.PanelManager"
local mSceneManager = nil
local mHeroManager = nil
local mCharManager = nil
local mNetManager = nil
local mCommonlyFunc = nil
local mRelationManager = nil
local mFriendChatPanel = nil
local mSystemTip = nil
local mAlert = nil
local mGuideManager = nil
local mGuidePanel = nil

module("LuaScript.View.Panel.View.CharViewPanel") -- 玩家人物信息
panelType = ConstValue.AlertPanel
local mChar = nil

function SetData(char)
	mChar = char
end

function Display()
	mMouseEventState = mSceneManager.GetMouseEventState()
	mSceneManager.SetMouseEvent(false)
end

function Hide()
	mSceneManager.SetMouseEvent(mMouseEventState)
end

function Init()
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mRelationManager = require "LuaScript.Control.Data.RelationManager"
	mFriendChatPanel = require "LuaScript.View.Panel.Friend.FriendChatPanel"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mGuideManager = require "LuaScript.Control.Data.GuideManager"
	mAlert = require "LuaScript.View.Alert.Alert"
	mGuidePanel = require "LuaScript.View.Panel.Task.GuidePanel"
	IsInit = true
end

function OnGUI()
	if not IsInit then
		return
	end
	local relationStr = mRelationManager.GetRelationStr(mChar)
	local id = mChar.id
	if mChar.type == CharacterType.ShipTeam then
		id = mChar.charId
	end
	
	local relation = mRelationManager.GetRelationById(id)
	-- GUI.BeginGroup(127.55, 50.05, 1186, 640)
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg2_2")
		GUI.DrawTexture(309.7,152.05,560, 350.1, image)
		
		
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot_"..(mChar.quality or 1))
		GUI.DrawTexture(371.7, 246.5, 128, 128, image)
		local image = mAssetManager.GetAsset("Texture/Character/Header/"..mChar.resId, AssetType.Pic)
		GUI.DrawTexture(376.7, 251.5, 100, 100, image)
		
		GUI.Label(477, 327, 0, 30,  "Lv:"..(mChar.level or Language[162]), GUIStyleLabel.Right_25_White,Color.Black)
		
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg4_1")
		GUI.DrawTexture(495.75,244.5,313.9,120,image,0,0,1,1,20,20,20,20)
		
		
		GUI.Label(457.7, 190.8, 256.2, 30,  mChar.name, GUIStyleLabel.Center_35_Black_Art)
		
		GUI.Label(527.85, 257, 256.2, 30, "类型: "..CharacterTypeStr[mChar.type], GUIStyleLabel.Left_25_Black)
		GUI.Label(527.85, 292, 256.2, 30, "关系: "..relationStr, GUIStyleLabel.Left_25_Black)
		
		local powerStr = Language[28] .. (mChar.power or Language[163])
		GUI.Label(527.85, 327, 256.2, 30,  powerStr, GUIStyleLabel.Left_25_Black)
		local oldEnabled = GUI.GetEnabled()
		local hero = mHeroManager.GetHero()
		if id == hero.id or (mChar.type ~= CharacterType.ShipTeam and mChar.type ~= CharacterType.Player) then
			GUI.SetEnabled(false)
		end
		if not relation or relation.type ~= 1 then
			if GUI.Button(362.45, 387.55, 111, 53, "私信", GUIStyleButton.ShortOrangeArtBtn) then
				-- mSceneManager.SetMouseEvent(true)
				mPanelManager.Hide(OnGUI)
				if mChar.type == CharacterType.ShipTeam then
					local char = CopyTable(mChar)
					char.id = id
					char.type = CharacterType.Player
					mFriendChatPanel.SetData(char)
				else
					mFriendChatPanel.SetData(mChar)
				end
				mPanelManager.Show(mFriendChatPanel)
			end
		else
			if GUI.Button(362.45, 387.55, 111, 53, "宽恕", GUIStyleButton.ShortOrangeArtBtn) then
				mRelationManager.RequestDelEnemy(id)
				mPanelManager.Hide(OnGUI)
				-- mSceneManager.SetMouseEvent(true)
			end
		end
		
		if not GUI.GetEnabled() then
			GUI.Button(473.8, 387.55, 111, 53, "查看", GUIStyleButton.ShortOrangeArtBtn)
		else
			GUI.SetEnabled(false)
			GUI.Button(473.8, 387.55, 111, 53, "查看", GUIStyleButton.ShortOrangeArtBtn)
			GUI.SetEnabled(true)
		end
		
		if not relation or relation.type ~= 0 then
			if GUI.Button(585.6, 387.55, 111, 53, "好友", GUIStyleButton.ShortOrangeArtBtn) then
				mRelationManager.RequestFriendById(id)
				mPanelManager.Hide(OnGUI)
				-- mSceneManager.SetMouseEvent(true)
			end
		else
			if GUI.Button(585.6, 387.55, 111, 53, "断交", GUIStyleButton.ShortOrangeArtBtn) then
				function okFunc()
					mRelationManager.RequestDelFriend(id)
					mPanelManager.Hide(OnGUI)
				end
				mAlert.Show("确定与好友断交？", okFunc)
				-- mSceneManager.SetMouseEvent(true)
			end
		end
		
		if mChar.type ~= CharacterType.ShipTeam and mChar.type ~= CharacterType.Player then
			GUI.SetEnabled(oldEnabled)
		end
		
		if GUI.Button(702.35, 387.55, 111, 53, "攻击", GUIStyleButton.ShortOrangeArtBtn) then
			local hero = mHeroManager.GetHero()
			if hero.level < 28 and (mChar.type ~= CharacterType.Enemy and mChar.type ~= CharacterType.NpcShipTeam) then
				mSystemTip.ShowTip("新手不能攻击该对象")
				return
			end
			mPanelManager.Hide(OnGUI)
			-- mSceneManager.SetMouseEvent(true)

			
			-- print(mChar.type)
			if (mChar.type ~= CharacterType.Enemy and mChar.type ~= CharacterType.NpcShipTeam)
				and hero.protectState then
				function OkFunc()
					Attack(mChar)
				end
				mAlert.Show("攻击该目标,当前保护状态将消失,是否继续?", OkFunc)
			elseif BreakMode(mChar) then
				function OkFunc()
					Attack(mChar)
				end
				mAlert.Show("攻击该目标,将自动切换成“战争模式”,是否继续?", OkFunc)
			else
				if relationStr == '好友' or relationStr == '盟友'   then
					function OkFunc()
						Attack(mChar)
					end
					mAlert.Show("您选择的攻击目标是您的<color=red>"..relationStr.."</color>,是否继续攻击?", OkFunc)
					else
					Attack(mChar)
				end
			end
		end
		
		if id == hero.id then
			GUI.SetEnabled(oldEnabled)
		end
		
		if GUI.Button(802.2, 139, 77, 63,nil, GUIStyleButton.CloseBtn) then
			mPanelManager.Hide(OnGUI)
			-- mSceneManager.SetMouseEvent(true)
			-- print("guanbi")
		end
	-- GUI.EndGroup()
end

function BreakMode(mChar)
	local hero = mHeroManager.GetHero()
	if hero.mode == 1 then
		return false
	end
	
	if hero.level < 28 then
		return false
	end

	if mChar.type == CharacterType.Enemy then
		local cfg_Enemy = CFG_Enemy[mChar.eid]
		if cfg_Enemy.isBoss ~= 0 then
			return true
		end
	end
	
	if mChar.type ~= CharacterType.Enemy and mChar.type ~= CharacterType.NpcShipTeam then
		return true
	end
end

function Attack(mChar)
	local char = mCharManager.GetChar(mChar.id)
	
	if char then
		mHeroManager.SetTarget(ConstValue.PlayerType, {char=char})
		mHeroManager.CheckAttackChar(char)
		
		-- mGuideManager.SetStopGuide(true)
		mPanelManager.Hide(mGuidePanel)
	else
		mSystemTip.ShowTip("攻击目标已不在附近")
	end
end

function RequestChat()
	-- print("RequestChat")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.PLAYER)
	ByteArray.WriteByte(cs_ByteArray,Packat_Player.REQUEST_REG_ACCOUNT)
	ByteArray.WriteInt(cs_ByteArray,mChar.id)
	mNetManager.SendData(cs_ByteArray)
end
