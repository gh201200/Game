-- UI层级
UILayer = {
	Normal = {
		name =  "Normal",
		index =	0,
	},
	Middle = {
		name =  "Middle",
		index =	1,
	},
	High = {
		name =  "High",
		index =	2,
	},
	Top = {
		name =  "Top",
		index =	3,
	},
}

-- UI动画类型
AnimationType = {
	None		=		"None",
	Alpha		=		"Alpha",
	Scale		=		"Scale",
	L2R			=		"L2R",
	R2L			=		"R2L",
	T2B			=		"T2B",
	B2T			=		"B2T",
}

-- 角色状态枚举
EntityState = {
	Idle = "Idle",						-- 站立
	Move = "Move",						-- 移动
	Patrol = "Patrol",					-- 游荡
	Chase = "Chase",					-- 追逐
	Dead = "Dead",						-- 死亡
	Attack = "Attack",					-- 攻击
	CastSkill = "CastSkill",			-- 释放技能
}

UIConfig = {
	LoadingPanel = {
		name = "LoadingPanel",
		prefabPath = "Prefabs/UI/LoadingPanel/LoadingPanel.prefab",
		luaPath = "UI.LoadingPanel",
		layer = UILayer.High,
		AnimationType = AnimationType.None,
	},
	LoginPanel = {
		name = "LoginPanel",
		prefabPath = "Prefabs/UI/LoginPanel/LoginPanel.prefab",
		luaPath = "UI.LoginPanel",
		layer = UILayer.Normal,
		AnimationType = AnimationType.None,
	},
	NormalDialog = {
		name = "NormalDialog",
		prefabPath = "Prefabs/UI/NormalDialog/NormalDialog.prefab",
		luaPath = "UI.NormalDialog",
		layer = UILayer.Middle,
		AnimationType = AnimationType.None,
	},
	HotfixPanel = {
		name = "HotfixPanel",
		prefabPath = "Prefabs/UI/HotfixPanel/HotfixPanel.prefab",
		luaPath = "UI.HotfixPanel",
		layer = UILayer.Middle,
		AnimationType = AnimationType.None,
	},
	TestPanel = {
		name = "TestPanel",
		prefabPath = "Prefabs/UI/Test/TestPanel.prefab",
		luaPath = "UI.TestPanel",
		layer = UILayer.Normal,
		AnimationType = AnimationType.None,
	},
}

EventType = {
	Test = 1,
	OnStartCheckUpdate = 2,				-- 开始检查更新
	OnUpdating = 3,						-- 正在更新
	OnCheckUpdateComplete = 4,			-- 检查更新完成
	QueryUpdate = 5,					-- 询问是否更新
	OnPanelOpen = 6,					-- 打开UI界面
	OnPanelClose = 7,					-- 关闭UI界面
	ShowVersion = 8,					-- 显示登录界面版本号
	OpenHotfixPanel = 9,				-- 打开调试界面	
	OnStateEnter = 10,					-- 进入XX状态
	OnStateExecute = 11,				-- XX状态正在执行
	OnStateExit = 12,					-- 退出XX状态
}