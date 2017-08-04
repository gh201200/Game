


ResUrl = "http://47.93.230.239/game/test/"
ErrorCollectUrl = "http://47.93.230.239/game/errorCollect.php"

local csApplication = luanet.import_type("UnityEngine.Application")
local csRuntimePlatform = luanet.import_type("UnityEngine.RuntimePlatform")
WindowsEditor = csApplication.platform:Equals(csRuntimePlatform.WindowsEditor)
WindowsPlayer = csApplication.platform:Equals(csRuntimePlatform.WindowsPlayer)
IPhonePlayer = csApplication.platform:Equals(csRuntimePlatform.IPhonePlayer)
Android = csApplication.platform:Equals(csRuntimePlatform.Android)

local csConfig = luanet.import_type("Config")
Version = csConfig.Version
BaseVersion = csConfig.BaseVersion

local temp = string.gsub(Version,"%.","0")
VersionNum = tonumber(temp)
local temp = string.gsub(BaseVersion,"%.","0")
BaseVersionNum = tonumber(temp)
platform = csConfig.platform
VersionCode = tonumber(csConfig.VersionCode)
VersionName = csConfig.VersionName

-- print(VersionCode)
-- platform = nil
SKD_name = "GameSdk"
if not platform then
	ServerListUrl = "http://47.93.230.239/game/test/serverList.php"
	IsDebug = true -- 是否开启DEBUG模式
	VersionCode = 99 -- 版本
elseif platform == "uc" then
	ServerListUrl = "http://47.93.230.239/game/uc/serverList.php"
	SKD_name = "UCGameSdk"
	-- IsDebug = true
elseif platform == "91" or platform == "91IOS" then
	ServerListUrl = "http://47.93.230.239/game/lj/serverList.php"
	-- IsDebug = true
elseif platform == "mi" then
	ServerListUrl = "http://47.93.230.239/game/lj/serverList.php"
	-- IsDebug = true
elseif platform == "dk" then
	ServerListUrl = "http://47.93.230.239/game/lj/serverList.php"
	-- IsDebug = true
elseif platform == "hw" then
	ServerListUrl = "http://47.93.230.239/game/lj/serverList.php"
	-- IsDebug = true
elseif platform == "lenovo" then
	ServerListUrl = "http://47.93.230.239/game/lj/serverList.php"
	-- IsDebug = true
elseif platform == "oppo" then
	ServerListUrl = "http://47.93.230.239/game/lj/serverList.php"
elseif platform == "main" then
	if IPhonePlayer then
		ServerListUrl = "http://47.93.230.239/game/main/serverList.php"
	else
		ServerListUrl = "http://47.93.230.239/game/main/serverList.php"
	end
elseif platform == "pp" then
	ServerListUrl = "http://47.93.230.239/game/lj/serverList2.php"
	-- IsDebug = true
elseif platform == "qxz" then
	ServerListUrl = "http://47.93.230.239/game/lj/serverList2.php"
	-- IsDebug = true
elseif platform == "ky" then
	ServerListUrl = "http://47.93.230.239/game/lj/serverList2.php"
	-- IsDebug = true
elseif platform == "lj" then
	ServerListUrl = "http://47.93.230.239/game/lj/serverList.php"
	-- IsDebug = true
elseif platform == "vivo" then
	ServerListUrl = "http://47.93.230.239/game/lj/serverList2.php"
	-- IsDebug = true
elseif platform == "yj" then
	SKD_name = "YJManager"
	ServerListUrl = "http://47.93.230.239/game/main/serverList.php"
	local YJManager = luanet.import_type("YJManager")
	local res = YJManager.GetMetaData("serverlist")
	ServerListUrl = res or ServerListUrl
end

if platform == "main" and IPhonePlayer then
	-- IosTestScript = true
end
-- IsDebug = true


UpdateNoticeUrl = "http://47.93.230.239/game/version/UpdateNotice.php"
NoticeVersionUrl = "http://47.93.230.239/game/version/NoticeVersion.php"

NewestVersion = {
	uc =		{VersionCode = 10, VersionName = "1.9", Url = "http://gproxy1.sm.cn/t/2/2/zfzh_uc_297346_14260019c45e.apk"},
	dk =		{VersionCode = 10, VersionName = "1.9", Url = "http://dl.m.duoku.com/game/cloud/67000/67357/20150513174123_DuoKu.apk"},
	["91"] =	{VersionCode = 10, VersionName = "1.9", Url = ""},
	["91IOS"] =	{VersionCode = 10, VersionName = "1.9", Url = ""},
	mi =		{VersionCode = 10, VersionName = "1.9", Url = "http://file.market.xiaomi.com/download/AppStore/080374802ebba8b55e1a4361a2999f99125433d81/%E5%BE%81%E6%9C%8D%E4%B9%8B%E6%B5%B7.apk"},
	hw = 		{VersionCode = 10, VersionName = "1.9", Url = "http://220.167.102.20/appdl.hicloud.com/dl/appdl/application/apk/31/317b6cb7176149e082e0b1b18746fba3/com.qiwankeji.zfzh.huawei.1504211502.apk"},
	lenovo = 	{VersionCode = 10, VersionName = "1.9", Url = "http://apkg.lenovomm.com/201505142043/0704f437862af2085faf167ff8f7c6ab/dlserver/fileman/crawler@cluster-1/ams/fileman/jar/2015-03-16112105-_1426519265900_4076.apk"},
	oppo = 		{VersionCode = 10, VersionName = "1.9", Url = "http://storedl1.nearme.com.cn/uploadFiles/Pfiles/201504/21/c8ab1db5aeb731fd503a9c8a863be9a1.apk"},
	main = 		{VersionCode = 10, VersionName = "1.9", Url = "http://pan.baidu.com/s/1qWLrcgG"},
	qxz = 		{VersionCode = 10, VersionName = "1.9", Url = ""},
	pp = 		{VersionCode = 10, VersionName = "1.9", Url = ""},
	ky = 		{VersionCode = 10, VersionName = "1.9", Url = ""},
	lj = 		{VersionCode = 10, VersionName = "1.9", Url = ""},
	vivo = 		{VersionCode = 10, VersionName = "1.9", Url = ""},
	yj = 		{VersionCode = 10, VersionName = "1.9", Url = ""},
}
if Android then
	NewestVersion.main.Url = "http://pan.baidu.com/s/1nt5ijbj"
end


if platform then
	NewestVersionCode = NewestVersion[platform].VersionCode
	NewestVersionName = NewestVersion[platform].VersionName
	NewestVersionUrl = NewestVersion[platform].Url
	IsNewestVersion = (NewestVersionCode <= VersionCode)
else
	NewestVersionCode = 999
	NewestVersionName = "9.9"
	NewestVersionUrl = ""
	IsNewestVersion = true
end



-- :GetValue(nil, nil):GetValue(0)
-- local csConfig = luanet.import_type("Config")
-- Version = csConfig.Version
-- print(Version)