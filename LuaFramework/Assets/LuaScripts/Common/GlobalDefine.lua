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
	OpenDebugPanel = 9,					-- 打开调试界面
}