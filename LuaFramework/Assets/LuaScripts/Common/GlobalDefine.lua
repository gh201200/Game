-- UI层级
UILayer = {
	Normal		=		"Normal",
	Middle		=		"Middle",
	High		=		"High",
	Top			=		"Top",
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

EventType = {
	Test = 1,
	OnStartCheckUpdate = 2,				-- 开始检查更新
	OnUpdating = 3,						-- 正在更新
	OnCheckUpdateComplete = 4,			-- 检查更新完成
	QueryUpdate = 5,					-- 询问是否更新
}