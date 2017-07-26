import "UnityEngine"
import "UnityEngine.UI"
import "UnityEngine.SceneManagement"
import "UnityEngine.EventSystems"
import "UnityEngine.Events"
import "DG.Tweening"
import "THGame.GameEntity"
import "THGame.GameLogic"
import "THGame.Network"
import "SLua"

require "luaext"
require "globalFunction"

g_Activity = require "activity"
g_CoolDown = require "cooldown"
g_TopRank = require "toprank"
g_Mails = require "mail"
g_Records = require "Records"
g_exploreManager = require "explore"
quest = require "quest"
Tween = ShortcutExtensions

local Entrance = {}

local this

function ClearAgentData()
	g_Activity:Clear()
	g_CoolDown:Clear()
	g_TopRank:Clear()
	g_Mails:Clear()
	g_exploreManager:Clear()
end

function GetIconName(iconName)
	local name = iconName
	if name == nil then
		name = ""
	end
	if not string.find(name, ".png") then name = name .. ".png" end
	return name
end

function ConvertTime(seconds)
	local h = math.floor(seconds / 3600)
	local m = math.floor((seconds - h * 3600) / 60)
	local s = seconds - h * 3600 - m * 60
	return math.floor(h), math.floor(m), math.floor(s)
end
	
--[[ 倒计时
	label:剩余时间输出到哪个Text控件上
	总倒计时时间，单位秒
	倒计时结束回调
--]]
function TimeDown(label, seconds, callback)
	local curTime, totalTime = 0, os.time() + seconds
	local co = coroutine.create(function()
		while true do
			Yield(WaitForSeconds(0.2))
			curTime = totalTime - os.time()
			local h, m, s = 0, 0, 0
			if curTime >= 0 then
				h, m, s = ConvertTime(curTime)
			else
				curTime = 0
				if callback then
					callback()
				else
					break
				end
			end
			local sh, sm, ss = tostring(h), tostring(m), tostring(math.floor(s))
			if h < 10 then sh = "0" .. sh end
			if m < 10 then sm = "0" .. sm end
			if s < 10 then ss = "0" .. ss end
			--label.text = "剩余刷新时间:\n     " .. "<color=#88FF8EFF>" .. sh .. ":" .. sm .. ":" .. ss .. "</color>"
			label.text = sh .. ":" .. sm .. ":" .. ss
			Debug.LogError(label.text)
		end
	end)
	coroutine.resume(co)
end

function GetNextHeroInfo(heroInfo)
    local nextInfo = ConfigReader.GetHeroInfo(heroInfo.id + 1)
    if nextInfo then
        return nextInfo
    else
        return heroInfo
    end
end

function GetQuest()
	return quest
end

function PlayFullLevel(fullLevel)
	local rt = fullLevel.parent:GetComponent(RectTransform)
	Tween.DOKill(fullLevel, false)
	rt.offsetMax = Vector2.zero
	rt.offsetMin = Vector2.zero
	rt.localPosition = Vector3.zero
	fullLevel.gameObject:SetActive(true)
	fullLevel.localPosition = Vector3(-142, 0, 0)
	local endPos = 429-- rt.rect.width / 2 + fullLevel:GetComponent(RectTransform).rect.width / 1.5
	local res = Tween.DOLocalMoveX(fullLevel, endPos, 1, false)
	TweenSetting.SetEase(res, Ease.OutSine)
	TweenSetting.SetLoops(res, -1, 0)
end

function StopFullLevel(fullLevel)
	Tween.DOKill(fullLevel, false)
	fullLevel.gameObject:SetActive(false)
end

function Entrance:Start()
    this = Entrance.this
	UIManager.Instance:OpenPanel("LoginPanel", true)
    -- Entrance:SwitchUI()

    -- 已经拥有的英雄
    MessageManager.AddListener(MsgType.UpdateHeroData, function(data)
		local camp1 = { }
		local camp2 = { }
		local camp3 = { }
		for p in Slua.iter(data) do
			local heroInfo = ConfigReader.GetHeroInfo(p.value.dataId)
			if heroInfo.n32Quality > 0 then
				if heroInfo.n32Camp == 1 then
					table.insert(camp1, heroInfo)
				elseif heroInfo.n32Camp == 2 then
					table.insert(camp2, heroInfo)
				elseif heroInfo.n32Camp == 4 then
					table.insert(camp3, heroInfo)
				end
			end
		end
		table.sort(camp1, function(left, right)
			return left.id < right.id
		end)
		table.sort(camp2, function(left, right)
			return left.id < right.id
		end)
		table.sort(camp3, function(left, right)
			return left.id < right.id
		end)
		local temp = { }
		for _, v in pairs(camp1) do
			table.insert(temp, v)
		end
		for _, v in pairs(camp2) do
			table.insert(temp, v)
		end
		for _, v in pairs(camp3) do
			table.insert(temp, v)
		end
        this:SetGlobalValue("ownedHeros", temp)
    end )

    -- 当前登录的账号信息
    MessageManager.AddListener(MsgType.UpdateAccountData, function(data)
        this:SetGlobalValue("Account", data)
    end )
end

function Entrance:SwitchUI()
    Debug.LogError("switch ui")
    local curName = SceneManager.GetActiveScene().name
    if curName == "UIScene" then
        UIManager.Instance:OpenPanel("LoginPanel", true)
    elseif curName == "pvp001" then
        UIManager.Instance:OpenPanel("BattlePanel", false)
    end
end

return Entrance
