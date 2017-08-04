--用游戏中聊天窗输入#debug可以调出脚本按钮，点击后就可以运行hotfix下的语句
local print = luanet.import_type("UnityEngine.Debug").Log
-- mRechargePanel = require "LuaScript.View.Panel.Recharge.RechargePanel"
-- mPanelManager.Show(mRechargePanel)

-- mDailyPanel = require "LuaScript.View.Panel.Daily.DailyPanel"
-- mPanelManager.Show(mDailyPanel)
-- mHeroManager.RequestSend(1)
-- mPanelManager.Show(require "LuaScript.View.Panel.Recharge.RechargePanel")


-- mHeroManager._Reset = mHeroManager.Reset
-- mHeroManager.Reset = function()
	-- mHeroManager._Reset()
	-- mSystemTip.ShowTip(1111)
-- end

-- local t = { }
-- t[1] = 1
-- t[1.5] = 1.5

-- print(t)

-- mHero = mHeroManager.GetHero()
-- print(mHero)

-- local JsonObj = luanet.import_type("JsonObj")
-- print(JsonObj)

-- local mHero = mHeroManager.GetHero()
-- print(mHero.x, mHero.y)

-- print(mActivityManager.GetActivityList())

-- require "LuaScript.View.Panel.Daily.DailyPanel".curLiveness = 70

mAwardPanel = require "LuaScript.View.Panel.AwardPanel"
mPanelManager.Show(mAwardPanel)

-- mHarborManager = require "LuaScript.Control.Scene.HarborManager"
-- temp = mHarborManager.GetSelfHarborList()
-- print(dumpTab(temp))


--显示指定文字
--mSystemTip.ShowTip("------11111111111--------")
--显示GUI绘制的界面
-- mRechangeViewPanel = require "LuaScript.View.Panel.FirstRechange.FirstRechange" --LuaScript脚本路径
-- mPanelManager = require "LuaScript.Control.PanelManager" -- panel的控制
-- mPanelManager.Show(mRechangeViewPanel) --显示面板


-- local gb = GameObject.Find("4222")
-- print(CsFindType("UnityEngine.Animator"))
-- local csAnimator =  GetComponent(gb,CsFindType("UnityEngine.Animator"))
-- csAnimator:Play("Greed")
-- print(GetComponent(gb,CsFindType("UnityEngine.Animator")))
-- local CSAnimation = CsFindType("UnityEngine.Animator")
-- mActivityManager.RequestFish()
 --local mHero = mHeroManager.GetHero()
-- print(os.oldTime)
-- print(table.remove({10,1,2}, 1))
-- local UmengAnalytics = Camera.mainCamera.gameObject:GetComponent("UmengAnalytics")
-- UmengAnalytics:Event("--------支付648RMB------------","hhahahahah")
-- for k,v in pairs(CFG_fishArea) do
		-- if mHero.map == v.mapId and mHero.x >= v.starX and mHero.x <= v.endX and
			-- mHero.y >= v.starY and mHero.y <= v.endY then
			-- -- if not mInFishArea then
				-- mSystemTip.ShowTip("发现大量鱼群")
			-- -- end
			-- -- mInFishArea = true
			-- return
		-- end
	-- end
	
	-- print(mActivityManager.CouldFish())

-- local mItemUseTip = require "LuaScript.View.Tip.ItemUseTip"
-- mItemUseTip.ShowTip(1)
-- print(mItemManager.GetItemById(1))
-- local mHero = mHeroManager.GetHero()
-- local mBattleFieldManager = require "LuaScript.Control.Data.BattleFieldManager"
-- mBattleFieldManager.RequestCommand(2, mHero.x,mHero.y, 2, mHero.name)
-- 432,518  901, 54
-- 564.5, 370, 111, 60,
-- CFG_guide[64] = {id = 34, type = 8, typeStr = "船员参战", x = 901, y = 54, width = 75, heigth = 60, dir = 3, cancelX = 915, cancelY = 315, desc = "点击关闭界面", force = 1, rect = 1, }
-- CFG_guide[65] = {id = 65, type = 14, typeStr = "物品使用" ,x = 574, y = 375, width = 100, heigth = 40, dir = 0, cancelX = 915, cancelY = 315, desc = "点击使用物品", force = 1, rect = 1, }
-- {id = 64, type = 14, typeStr = "物品使用", x = 167, y = 150, width = 100, heigth = 100, dir = 1, cancelX = 915, cancelY = 315, desc = "点击打开物品背包", force = 1, rect = 1, }
-- C
-- CFG_guide[103] = {id = 103, type = 26, typeStr = "进入商队", x = 905, y = 54, width = 75, heigth = 60, dir = 3, cancelX = 915, cancelY = 315, desc = "点击关闭界面", force = 1, rect = 1, }

-- CFG_guide[34] = {id = 34, type = 8, typeStr = "船员参战", x = 881, y = 77, width = 75, heigth = 60, dir = 3, cancelX = 915, cancelY = 315, desc = "点击关闭界面", force = 1, rect = 1, }
-- CFG_guide[117] = {id = 117, type = 29, typeStr = "使用技能", x = 520, y = 500, width = 128, heigth = 128, dir = 1, cancelX = 1015, cancelY = 370, desc = "点击海面进行移动", force = 0, rect = 0, }
-- CFG_guide[118] = {id = 118, type = 29, typeStr = "使用技能", x = 0, y = 85, width = 90, heigth = 95, dir = 2, cancelX = 1015, cancelY = 370, desc = "战争咆哮可使用\n(提升海量攻击力)", force = 0, rect = 1, }
-- CFG_guide[119] = {id = 119, type = 29, typeStr = "使用技能", x = 0, y = 183, width = 90, heigth = 95, dir = 2, cancelX = 1015, cancelY = 370, desc = "火炎爆可使用\n(超高单体伤害)", force = 0, rect = 1, }
-- CFG_guide[120] = {id = 120, type = 29, typeStr = "使用技能", x = 0, y = 281, width = 90, heigth = 95, dir = 2, cancelX = 1015, cancelY = 370, desc = "雷神之怒可使用\n(秒杀全体敌方船只)", force = 0, rect = 1, }

-- local mMap = require "LuaScript.View.Scene.Map"
-- mMap.SetCommand(1)
-- mSetManager.SetGuide(true)
-- AppearEvent(nil,EventType.OnRefreshGuide)
--mSailorViewPanel = require "LuaScript.View.Panel.Sailor.SailorViewPanel"
--mPanelManager.Show(mSailorViewPanel)

-- mAlert = require "LuaScript.View.Alert.Alert"
-- mPanelManager.Hide(mAlert)
-- print(mSailorViewPanel)
-- print(mHero.lastShowTime)
-- print(mHero.map)
-- print(os.oldClock - 1)
-- if mHero.lastShowTime < os.oldClock - 1 and mHero.map == 1 and mHero.ships[1] then
	-- mHero.lastShowTime = os.oldClock
	-- mSceneTip.ShowTip(mHero.ships[1].x,0,mHero.ships[1].y-40, "食物-1", Color.RedStr, "Rise&Sacle")
-- end
-- mSceneTip = require "LuaScript.View.Tip.SceneTip"
-- mSceneTip.ShowTip(mHero.ships[1].x,0,mHero.ships[1].y-40, "食物-1", Color.YellowStr)
-- ffdf2 = ffdf2 or 1
-- for k,v in pairs(CFG_harbor) do
	-- v.background = ffdf2
-- end

-- ffdf2 = ffdf2+1

-- print(math.floor(20/20)%2*1000)

-- local mHotFixPanel = require "LuaScript.View.Panel.HotFixPanel"
-- mHotFixPanel.starid = ffdf2


-- print(math.floor(20/20)%2*0.5)

-- local hero = mHeroManager.GetHero()
-- print( hero.battleId)

-- local hero = mHeroManager.GetHero()

-- print(mCharManager.GetCsShip(hero.ships[1].id))
-- mCharManager.Hurt(hero.ships[1].id)

-- local animation = GetComponentInChildren(cs_ship, Animation.GetType())
-- CsAnimationPlay(animation, "Rock2")
-- local cs_ship = mCsShipList[shipId]
		-- local animation = GetComponentInChildren(cs_ship, Animation.GetType())
		-- CsAnimationPlay(animation, AnimationType.Sink)

-- local starSkill = CFG_starSkill[19]
-- local starSkillProperty = CFG_starSkillProperty["19_3"]
-- if 
-- local property = CFG_property[starSkillProperty.target1]
-- local cfg_starSkill = CFG_starSkill[19]	
-- local starSkillProperty = CFG_starSkillProperty[19 .."_".. 4]
-- local s1 = ""
-- if starSkillProperty.hurtType1 == 1 then
	-- s1 = mCommonlyFunc.BeginColor(Color.RedStr)..starSkillProperty.value1..mCommonlyFunc.EndColor()
-- elseif starSkillProperty.hurtType1 == 2 then
	-- s1 = mCommonlyFunc.BeginColor(Color.OrangeStr)..starSkillProperty.value1..mCommonlyFunc.EndColor()
-- elseif starSkillProperty.hurtType1 == 3 then
	-- s1 = mCommonlyFunc.BeginColor(Color.RedStr)..starSkillProperty.value1.."%%"..mCommonlyFunc.EndColor()
-- elseif starSkillProperty.hurtType1 == 4 then
	-- s1 = mCommonlyFunc.BeginColor(Color.OrangeStr)..starSkillProperty.value1.."%%"..mCommonlyFunc.EndColor()
-- end
-- local s2 = ""
-- if starSkillProperty.hurtType2 == 1 then
	-- s2 = mCommonlyFunc.BeginColor(Color.RedStr)..starSkillProperty.value2..mCommonlyFunc.EndColor()
-- elseif starSkillProperty.hurtType2 == 2 then
	-- s2 = mCommonlyFunc.BeginColor(Color.OrangeStr)..starSkillProperty.value2..mCommonlyFunc.EndColor()
-- elseif starSkillProperty.hurtType2 == 3 then
	-- s2 = mCommonlyFunc.BeginColor(Color.RedStr)..starSkillProperty.value2.."%%"..mCommonlyFunc.EndColor()
-- elseif starSkillProperty.hurtType2 == 4 then
	-- s2 = mCommonlyFunc.BeginColor(Color.OrangeStr)..starSkillProperty.value2.."%%"..mCommonlyFunc.EndColor()
-- end
-- print(string.format(cfg_starSkill.desc, s1, s2))

-- local mAutoBusinessManager = require "LuaScript.Control.Data.AutoBusinessManager"
-- mAutoBusinessManager.init()
-- mAutoBusinessManager.StarAutoBusiness(1)
-- local selectSailor = mSailorManager.GetSailorByDuty(2)
-- local nextStar = selectSailor.star+1
-- local cfg_sailor = CFG_UniqueSailor[selectSailor.index]
-- mSailorManager.RequestStarUp(selectSailor.id)
-- print(nextStar)
-- print(cfg_sailor["starSkillId"..nextStar])
	-- local cfg_skill = CFG_skill[cfg_sailor["starSkillId"..nextStar]]
	-- print(cfg_skill)
-- print(selectSailor.exLevel)

-- local str = ""
-- for i=0,5000,1 do
	-- str = str .. "1"
-- end
 -- mNetManager = require "LuaScript.Control.System.NetManager"
-- local cs_ByteArray = ByteArray.Init()
-- ByteArray.WriteByte(cs_ByteArray,PackatHead.PLAYER)
-- ByteArray.WriteByte(cs_ByteArray,Packat_Player.REQUEST_IOS_ADD_BILL)
-- ByteArray.WriteUTF(cs_ByteArray,str,5000)
-- ByteArray.WriteUTF(cs_ByteArray,"222222",50)
-- mNetManager.SendData(cs_ByteArray)

-- mPanelManager = require "LuaScript.Control.PanelManager"
-- local mharbor = require "LuaScript.View.Panel.Harbor.HarborPanel"
-- local mHotFixPanel = require "LuaScript.View.Panel.HotFixPanel"
-- local mHeroPanel = require "LuaScript.View.Panel.HeroPanel"
-- mPanelManager.Reset()
-- mPanelManager.Show(mHotFixPanel)
-- local mCopyMapPanel = require "LuaScript.View.Panel.CopyMap.CopyMapPanel"
-- mPanelManager.Show(mCopyMapPanel)
-- print(math.ceil(1))

-- function GotoHarbor(id)
	-- if not id then
		-- id = 2
	-- end
	-- print(id)
-- end

-- GotoHarbor()
-- print(id)
-- GotoHarbor(3)

-- mHeroManager.GotoHarbor()
-- print(mHeroManager.GetHero().harborId)
-- print(mSailorManager.GetSailors()[2].id)
-- print(mEquipManager.GetBetterEquip(mSailorManager.GetSailors()[1].id,1))
-- print(mEquipManager.GetEquipsByType(4,true))
-- local itemId = ConstValue.QualityUpItem[1]
	-- local item = mItemManager.GetItemById(itemId)
-- print(item)
-- local cfg_item = CFG_item[49]
-- print(cfg_item)
-- v = CFG_starSkill[1]
-- local key = string.format("%d_%d_%d_%d_%d_%d_%d",v.star1*10,v.star2*10,v.star3*10,v.star4*10,v.star5*10,v.star6*10,v.star7*10)
-- print(key)
-- print(string.gsub(key,"_0*","%%d*"))

-- local mStarFateManager = require "LuaScript.Control.Data.StarFateManager"
-- local a,b,c = mStarFateManager.CouldActionSkills(1)
-- print(mStarFateManager.GetStarByIndex(38))
-- local t = {11}
-- print(a[1])
-- print(table.remove(t,1))
-- print(table.remove(t,#t))
-- print(mStarFateManager.GetUnuseStarList())
-- print(c)
-- local mStarGetPanel = require "LuaScript.View.Panel.StarFate.StarGetPanel"
-- local mStarSelectPanel = require "LuaScript.View.Panel.StarFate.StarSetPanel"
-- local mStarSkillSelectPanel = require "LuaScript.View.Panel.StarFate.StarSkillSelectPanel"

-- print(mStarGetPanel.visible, mStarSelectPanel.visible, mStarSkillSelectPanel.visible)
-- local list = mStarFateManager.ExStarList(1)
-- print(list[1])
-- print(list[2])
-- print(list[3])
 -- key = "1100010001000222222020033455500660607777"
-- print(CFG_starSkill[7].key4)
-- print(string.find("1100010001000222222020033455500660607777",CFG_starSkill[7].key4))


-- for k,v in pairs(CFG_starSkill) do
-- v = CFG_starSkill[7]
		-- local find = false
		-- if v.key4 then
			-- find = string.find(key, v.key4)
			-- if find then
				-- local skill = {id=v.id,quality=4}
				-- table.insert(skillList, skill)
				-- skillListById[v.id] = skill
			-- end
		-- end
		-- print()
		


-- if true then
	-- return 
-- end

-- local mActivityManager =require "LuaScript.Control.Data.ActivityManager"
-- local serverTime = mActivityManager.GetServerTime()
-- severId = 1
-- for k,v in pairs(CFG_accumulatedAmount) do
		-- if k == 77 then
		-- if v.startTime > 1388505600 then
		-- print(1)
		-- print(v.startTime)
		-- print(serverTime)
		-- print(v.endTime)
			-- if v.startTime <= serverTime and v.endTime > serverTime then
				-- print(11111111)
			-- end
		-- else
			-- -- if v.startTime <= serverStartOverTime and v.endTime > serverStartOverTime and v.starSever <= severId and
				-- -- v.endSever >= severId then
				-- -- print(11111111)
			-- -- end
		-- end
	
			-- print(v)
		-- end
	-- end

-- print(111)
--mSystemTip.ShowTip("1")
-- AppearEvent(nil,EventType.SDKLoginOut)
-- local mGamblePanel =  require "LuaScript.View.Panel.Activity.Gamble.GamblePanel"
-- print(mGamblePanel.mState)
-- mEquipManager = require "LuaScript.Control.Data.EquipManager"
	-- mLabManager = require "LuaScript.Control.Data.LabManager"
	-- mSetManager = require "LuaScript.Control.System.SetManager"
	-- mSendManager = require "LuaScript.Control.Scene.SendManager"
	-- mHarborManager = require "LuaScript.Control.Scene.HarborManager"
	-- mPathFindManager = require "LuaScript.Control.Scene.PathManager"
	-- mCharacter = require "LuaScript.Mode.Object.Character"
	-- mAssetManager = require "LuaScript.Control.AssetManager"
	-- mEventManager = require "LuaScript.Control.EventManager"
	-- mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	-- mLoginPanel = require "LuaScript.View.Panel.Login.LoginPanel"
	-- mLoadPanelPanel = require "LuaScript.View.Panel.LoadPanel"
	-- mPanelManager = require "LuaScript.Control.PanelManager"
	-- mNetManager = require "LuaScript.Control.System.NetManager"
	-- mCharManager = require "LuaScript.Control.Scene.CharManager"
	-- mMoveManager = require "LuaScript.Control.Scene.MoveManager"
	-- mCreateHeroPanel = require "LuaScript.View.Panel.Login.CreateHeroPanel"
	-- mHeroTip = require "LuaScript.View.Tip.HeroTip"
	-- mHarborIntoPanel = require "LuaScript.View.Panel.Harbor.HarborIntoPanel"
	-- mShipResManager = require "LuaScript.Control.Data.ShipResManager"
	-- mSailorManager = require "LuaScript.Control.Data.SailorManager"
	-- mShipManager = require "LuaScript.Control.Data.ShipManager"
	-- mCameraManager = require "LuaScript.Control.CameraManager"
	-- mTaskManager = require "LuaScript.Control.Data.TaskManager"
	-- mLevelUpTip = require "LuaScript.View.Tip.LevelUpTip"
	-- mPowerChangeTip = require "LuaScript.View.Tip.PowerChangeTip"
	-- mAudioManager = require "LuaScript.Control.System.AudioManager"
	-- mSystemTip = require "LuaScript.View.Tip.SystemTip"
	-- mConnectAlert = require "LuaScript.View.Alert.ConnectAlert"
	-- mAddItemTip = require "LuaScript.View.Tip.AddItemTip"
	-- mCloudManager = require "LuaScript.Control.Scene.CloudManager"
	-- mMap = require "LuaScript.Control.Scene.CloudManager"
	-- mAlert = require "LuaScript.View.Alert.Alert"
	-- mTargetManager = require "LuaScript.Control.Scene.TargetManager"
	-- mBattleManager = require "LuaScript.Control.Data.BattleFieldManager"
	-- mSea = require "LuaScript.View.Scene.Sea"
	-- m3DTextManager = require "LuaScript.Control.Scene.3DTextManager"
	-- mItemManager = require "LuaScript.Control.Data.ItemManager"
	-- mTreasureManager = require "LuaScript.Control.Scene.TreasureManager"
	-- mActivityManager = require "LuaScript.Control.Data.ActivityManager"
	-- mShopPanel = require "LuaScript.View.Panel.Harbor.ShopPanel"
	-- mShipEquipManager = require "LuaScript.Control.Data.ShipEquipManager"
	-- mFamilyManager = require "LuaScript.Control.Data.FamilyManager"
	-- mPowerUpTip = require "LuaScript.View.Panel.PowerUp.PowerUpTip"
	-- mModePanel = require "LuaScript.View.Panel.Mode.ModePanel"
	-- mSDK = require "LuaScript.Mode.Object.SDK"
	-- mStarFateManager = require "LuaScript.Control.Data.StarFateManager"
	
-- local equipPower = mEquipManager.GetTotalPower()
-- local sailorPower = mSailorManager.GetTotalPower()
-- local shipPower = mShipManager.GetTotalPower()
-- local shipEquipPower = mShipEquipManager.GetTotalPower()
-- local labPower = mLabManager.GetTotalPower()
-- local starPower = mStarFateManager.GetTotalPower()

-- local power = equipPower + sailorPower + shipPower + labPower + shipEquipPower + starPower

-- print( equipPower + sailorPower)
-- print( sailorPower)
-- print( labPower )
-- print( starPower)
-- wefw.f = 1
--print(Event.GetCurrent() and Event.GetCurrent().type)
-- joystick:Show()

--mSceneManager.SetMouseEvent(false)

-- function MoveShip(_, _, dir)
	-- local hero = mHeroManager.GetHero()
	-- local pos = {}
	-- pos.x = hero.x
	-- pos.y = hero.y
	-- local speed = 100
	-- local targetPos = {x = pos.x + dir.x * speed, y = pos.y + dir.y * speed}
	-- mHeroManager.Goto(hero.map, targetPos.x, targetPos.y)
-- end

-- local hero = mHeroManager.GetHero()
-- local pos = {}
-- pos.x = hero.x
-- pos.y = hero.y
-- local speed = 50
-- local dir = {x = 1, y = 0}
-- local targetPos = {x = pos.x + dir.x * speed, y = pos.y + dir.y * speed}
-- mHeroManager.Goto(hero.map, 7584, 11705)
--mSystemTip.ShowTip("test tip", Color.BlueStr)

-- joystick = require "LuaScript.View.Joystick"
-- if not joystick.visible then
	-- --mEventManager.AddEventListen(nil, EventType.ChangeDir, MoveShip)
	-- joystick.enterDis = 120
	-- mPanelManager.Show(joystick)
-- else
	-- --mEventManager.RemoveEventListen(nil, EventType.ChangeDir, MoveShip)
	-- mPanelManager.Hide(joystick.OnGUI)
-- end

