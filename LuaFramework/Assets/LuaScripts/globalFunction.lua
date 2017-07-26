--三个英雄全局函数


--添加元素到一个表中
function InsertTableMember(t,m)
	if not t then
		log("the table is nil");
		return ;
	end
	if t[m] ~= nil then
		t[m] = t[m]+1;
		return;
	end
	if t.count ==nil then
		t.count = 1;
	else
		t.count = t.count + 1;
	end
	
	t[m] = 1;
end

--删除表中所有该元素
function RemoveTableMember(t,m)

	if not t then
		log("the table is nil");
		return false;
	end
	if t.count == nil then
		return;
	end
	t.count = t.count - 1;
	if t.count == 0 then
		t.count = nil;
	end
	t[m] = nil;
end

--判断元素是否在表中
function IsTableMember(t,m)

	if not t then
		log("the table is nil");
		return false;
	end
	if t[m] ~= nil then
		return true;
	end
	return false;
end

--合并2个表（t2合并到t1中）
function UnionTableMember(t1,t2)
	--如果t2为空表直接返回t1
	if t2 == nil or t2.count == nil or t2.count == 0 then
		return t1;
	end
	if t1 == nil or t1.count == nil or t1.count == 0 then
		return t2;
	end
	local uniontable = {};

	for k,_ in pairs(t1) do
		if tostring(k) ~= "count" and type(k) ~= "table" then
			InsertTableMember(uniontable,k);
		end
	end
	for k,_ in pairs(t2) do
		if tostring(k) ~= "count" and type(k) ~= "table" then
			InsertTableMember(uniontable,k);
		end
	end
	return uniontable;
end

--输出整张表内容
function printTable(tt)

	if not tt then
		log("the table is nil");
		return
	end
	for k,v in pairs(tt) do
		if v ~= nil then
			log("%s--->%s",tostring(k),tostring(v));
		end
	end
end

--输出表中表内所有内容
function printMap(tt)
	log("now begin to print map");
	for k,v in pairs(tt) do
		if v ~= nil then
			log("%s--->%s::",tostring(k),tostring(v));
			printTable(v)
		end
	end
end

--输出整张表内容
function Table_Is_Empty(t)
	return _G.next(t) == nil
end

--获得表中元素个数
function Table_Get_N(t)
	if not t then return 0 end
	local n = 0
	for k,v in pairs(t) do
		if v ~= nil then
			n = n + 1
		end
	end
	return n
end

function dostring(str)
	loadstring(str)();
end

function dohasfile(str)
	local hFile = io.open(str,"r");

	if hFile then
		io.close(hFile);
		dofile(str);
	end
end

-- 禁止使用未定义全局变量
function disableUndeclaredVar()
    setmetatable(_G,{
        __newindex = function(_,n)
			logerror("全局变量未定义不能赋值:"..n);

			unenableDisableUndeclaredVar();
			logerror(debug.traceback());
			disableUndeclaredVar()
        end,

        __index = function(_,n)
			logerror("全局变量未定义不能引用:"..n);
			unenableDisableUndeclaredVar();
			logerror(debug.traceback());
			disableUndeclaredVar()
        end,
    })
end

--定义全局变量
function g_var(name,initValue)
	if rawget(_G, name) ~= nil then
		assert(false,"全局变量重复定义");
	end

    rawset(_G,name,initValue or false);
end

function unenableDisableUndeclaredVar()
	setmetatable(_G,nil);
end

--返回随机n位字符串，数字组成
function randName(nCount)

	local str = "";

	for i = 0,nCount - 1 do
		str = str .. tostring(math.random(0,9));
	end

	return str;
end

function disableInvalidAccess(tbl)
	setmetatable(tbl,{
        __index = function(_,n)
			logerror("成员变量未定义不能访问:"..tostring(n));
			logerror(debug.traceback());
        end,
    })
end

function disableClassInvalidAccess(tbl)
	setmetatable(tbl,{
        __index = function(_,n)
			logerror("成员变量未定义不能访问:"..tostring(n));
			logerror(debug.traceback());
        end,

		__newindex = function(_,n)
			logerror("成员变量未定义不能赋值:"..tostring(n));
			logerror(debug.traceback());
        end,
    })
end

function line()
	log("-------------------------------------------------");
end


--------------------------------------------------------------------------------------------------
--继承一个table,调用Create函数
--给没有元表的table设置元表。
--如果已经有元表，得到元表的table设置元表
function public(self, class)
	local tself = self;
	while(true) do
		if (tself == nil) then
			print("tself id nil");
			break
		end

		if (getmetatable(tself) ~= nil) then
			if(class == getmetatable(tself).__index) then
				if (class.Create ~= nil and type(class.Create) == "function") then
					class:Create(self);
				end
				print("重复继承");
				break;
			else
				tself = getmetatable(tself).__index;
			end
		else
			if (class.Create ~= nil and type(class.Create) == "function") then
				class:Create(self);
			end
			setmetatable(tself,{__index = class})
			break;
		end
	end
end

--------------------------------------------------------------------------------------------------

function formatString(...)
	local formatStr = "";

	local n = select('#',...)
	for i=1,n do
		local v = select(i,...)
		if type(v) == "boolean" then
			if v then
				v = 1;
			else
				v = 0;
			end
		end

		if type(v) == "userdata" then
			v = tostring(v);
		end

		if formatStr ~= "" then
			formatStr = formatStr .. "," .. v;
		else
			formatStr = v
		end
	end

	return formatStr;
end

function getMax(val1, val2)
	if not val1 then return val2 end
	if not val2 then return val1 end
	return ((val1 > val2) and val1) or val2
end

function getMin(val1, val2)
	if not val1 then return val1 end
	if not val2 then return val2 end
	return ((val1 < val2) and val1) or val2
end

function clamp(val, min, max)
	return math.max(math.min(val, max), min)
end

------------------------------------------------------------------------------------
--系统时间相关全局函数
--08/20/13 22:12:34
function GetCurStringTime()
	local time = os.date();
	return time;
end
--1377007957
function GetCurIntegerTime()
	local time = os.time();
	return time;
end

--time.year--->2013年
--time.month--->8月
--time.day--->20日
--time.hour--->22时
--time.min--->6分
--time.sec--->18秒
--time.wday--->3（星期几，周日为1周六为7）
--time.yday--->232(年内天数)
--time.isdst--->false（日光节约时间）
function GetCurTableTime()
	local time = os.date("*t",os.time());
	return time;
end

--查看是否过期
--nbegintime 开始时间
--freshtime  保质期(天)
--difftime   比较时间
--比如 一个牛奶 生产日期 9月1号 保质期 7 天 比较日期 9月10号
--那么这个牛奶在9月10号就过期了
function IsTimeOverdueforDay(nbegintime,freshtime,difftime)
	 
	 local tt1 = os.date("*t", nbegintime);
	 local tt2 = os.date("*t", difftime);

	 --printTable(tt1);
	 --log("-----------")
	 --printTable(tt2);
	 AddDateDay(tt1, freshtime);
	 --log("-----------")
	 --printTable(tt1);
	 nbegintime = os.time(tt1);

	 --log("%d,%d",nbegintime,difftime)
	 if nbegintime <= difftime then
	 --	log("过期");
		return true;

	 else
--		log("未过期");
		return false;
	 end
end

function GetTimeZone()
	local now = os.time()
	return os.difftime(now, os.time(os.date("!*t", now)))
end
g_timezone = GetTimeZone()

function IsLeapYear(year)
	return year % 4 == 0 and (year % 100 ~= 0 or year % 400 == 0)
end

function GetDaysInMonth(year, month)
	return month == 2 and IsLeapYear(year) and 29 or("\31\28\31\30\31\30\31\31\30\31\30\31"):byte(month)
end

function AddDateYear(dt, year)
	dt.year = dt.year + year
end

function AddDateMonth(dt, month, clampDays)
	dt.month = dt.month + month
	if dt.month > 12 then
		local y = math.floor(dt.month / 12)
		dt.month = dt.month % 12
		AddDateYear(dt, 1)
	end
	-- clamp days
	if clampDays ~= false then
		dt.day = getMin(dt.day, GetDaysInMonth(dt.year, dt.month))
	end
end

function AddDateDay(dt, day)
	dt.day = dt.day + day
	while true do
		local maxDay = GetDaysInMonth(dt.year, dt.month)
		if dt.day > maxDay then
			dt.day = dt.day - maxDay
			AddDateMonth(dt, 1, false)
		else
			break
		end
	end
end

function AddDateHour(dt, h)
	dt.hour = dt.hour + h
	if dt.hour > 24 then
		local day = math.floor(dt.hour / 24)
		dt.hour = dt.hour % 24
		-- tail call
		return AddDateHour(dt, day)
	end
end

function AddDateMin(dt, min)
	dt.min = dt.min + min
	if dt.min > 60 then
		local h = math.floor(dt.min / 60)
		dt.min = dt.min % 60
		-- tail call
		return AddDateHour(dt, h)
	end
end

function AddDateSec(dt, sec)
	dt.sec = dt.sec + sec
	if dt.sec > 60 then
		local min = math.floor(dt.sec / 60)
		dt.sec = dt.sec % 60
		-- tail call
		return AddDateMin(dt, min)
	end
end

function AddDate(dt, add)
	if add.year then AddDateYear(dt, add.year) end
	if add.month then AddDateMonth(dt, add.month) end
	if add.day then AddDateDay(dt, add.day) end
	if add.hour then AddDateHour(dt, add.hour) end
	if add.min then AddDateMin(dt, add.min) end
	if add.sec then AddDateYear(dt, add.sec) end
end

local DateDay = {"sec", "min", "hour", "day", "month", "year"}
function nextDay(nextDate)
	local now = os.time()
	-- calc
	local target = {}
	local valid = 0
	while true do
		if not nextDate[DateDay[valid+1]] then break end
		valid = valid + 1
		target[DateDay[valid]] = nextDate[DateDay[valid]]
	end
	-- invalid input
	if 0 == valid then return false end
	if 6 == valid then
		if now > os.time(target) then
			return false
		else
			return target
		end
	end
	-- get next
	local dt = os.date("*t", now)
	local isCarry = false
	for i=valid,1,-1 do
		if target[DateDay[i]] > dt[DateDay[i]] then
			isCarry = false
			break
		elseif target[DateDay[i]] < dt[DateDay[i]] then
			isCarry = true
			break
		end
	end
	for i=valid+1,6 do
		target[DateDay[i]] = dt[DateDay[i]]
	end
	if isCarry then AddDate(target, {[DateDay[valid+1]] = 1}) end
	return target
end

local DateWday = {"sec", "min", "hour", "wday"}
function nextWday(nextDate)
	if not nextDate.wday then return false end
	-- default with 0
	local target = {}
	for i=1,4 do
		target[DateWday[i]] = nextDate[DateWday[i]] or 0
	end
	-- carry?
	local now = os.time()
	local dt = os.date("*t", now)
	local isCarry = false
	for i=4,1,-1 do
		if target[DateWday[i]] > dt[DateWday[i]] then
			isCarry = false
			break
		elseif target[DateWday[i]] < dt[DateWday[i]] then
			isCarry = true
			break
		end
	end
	-- get next
	target.day = dt.day
	target.month = dt.month
	target.year = dt.year
	local addtion = isCarry and 7 or 0
	AddDate(target, {day = (target.wday - dt.wday + addtion)})
	return target
end

local DateYday = {"sec", "min", "hour", "yday", "year"}
function nextYday(nextDate)
	if not nextDate.yday then return false end
	local now = os.time()
	local dt = os.date("*t", now)
	-- default with 0
	local target = {}
	for i=1,4 do
		target[DateYday[i]] = nextDate[DateYday[i]] or 0
	end
	target.year = nextDate.year or dt.year
	-- carry?
	local isCarry = false
	for i=5,1,-1 do
		if target[DateYday[i]] > dt[DateYday[i]] then
			isCarry = false
			break
		elseif target[DateYday[i]] < dt[DateYday[i]] then
			isCarry = true
			break
		end
	end
	-- get next
	if isCarry then
		if nextDate.year then return false end
		AddDate(target, {year = 1})
	end
	-- just in case
	target.yday = getMin(target.yday, (IsLeapYear(target.year) and 366 or 365))
	-- convert to month day
	target.month = 1
	target.day = target.yday
	while target.day > GetDaysInMonth(target.year, target.month) do
		target.day = target.day - GetDaysInMonth(target.year, target.month)
		target.month = target.month + 1
	end
	return target
end

--获得y年m月d天是星期几(蔡勒公式)
--0-星期日，1-星期一，2-星期二，3-星期三，4-星期四，5-星期五，6-星期六
function getWeekDay_Zeller(y, m, d)
	local c = math.floor(y/100)
	y = y % 100
	if m==1 or m==2 then
		y = y - 1
		m = 12 + m
	end
	local w = math.floor(c/4)-2*c+y+math.floor(y/4)+math.floor((m+1)*13/5)+d-1
	w = w % 7
	return w
end


function lua_string_split(str, split_char)
	local sub_str_tab = string.split(str, split_char)
    return sub_str_tab;
end

function mClamp(val, low, high)
	return math.max(math.min(val, high), low);
end

--取整
function mRound (val)
    local fval = math.abs(val)
    local ival = 0
    if fval - math.floor(fval) >= 0.5 then
        ival = math.ceil(fval)
    else
        ival = math.floor(fval)
    end

    if val >= 0 then
        return ival
    else
        return -ival
    end
end

function bit(a)
	return Api.bit(a)
end

function bit_or(a, b)
	return Api.bit_or(a, b)
end

function bit_and(a, b)
	return Api.bit_and(a, b)
end

--按位与
function luaHasBit(a,b)
	if bit_and(a, b)==b then
		return true
	end
	return false
end

--将数据库时间转化为秒数
function dbTimeToOStime(dbtime)
	local ostime = 0
	if dbtime ~= nil then
		local timeTable = lua_string_split(dbtime," ")

		local size = table.getn(timeTable)
		if size == 2 then
			local datetable = lua_string_split(timeTable[1],"-")
			local timetable = lua_string_split(timeTable[2],":")
			if table.getn(datetable) == 3 and table.getn(timetable) == 3 then
				ostime = os.time({year=datetable[1],month=datetable[2],day=datetable[3],hour=timetable[1],min=timetable[2],sec=timetable[3]})
			end
		end
		if ostime == 0 then
			if dbtime > 0 then
				return dbtime
			end
		end
	end
	return ostime
end

--table 排序
function table_sort(st, func)
	table.sort(st, func)
	--[[
	/*
	local sz = #st
	for i=1, sz do
		for j=i+1, sz do
			if not func(st[i], st[j]) then
				tmp = st[j]
				st[j] = st[i]
				st[i] = tmp
			end
		end
	end
	--]]
end
--拷贝表
function table_copy(st)
    local tab = {}
    for k, v in pairs(st or {}) do
        if type(v) ~= "table" then
            tab[k] = v
        else
            tab[k] = table_copy(v)
        end
    end
    return tab
end

--发送网络消息
function sendNetMsg(key, sp)
	Api.sendMsg(key, sp)
end
--注册网络消息
function registerMsgHandler(key, hanlder)
	Api.registerMsgHandler(key, hanlder)
end

--按照排序后的keys遍历table
function pairsByKeys(t, sortFunc)  
	    local a = {}  
	    for n in pairs(t) do  
	        a[#a+1] = n  
	    end  
	    table.sort(a, sortFunc)  
	    local i = 0 
	    return function()  
	        i = i + 1  
	        return a[i], t[a[i]]  
	    end  
end

-- 计算字符串长度
function string.utf8len(input)  
    local len  = string.len(input)  
    local left = len  
    local cnt  = 0  
    local arr  = {0, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc}  
    while left ~= 0 do  
        local tmp = string.byte(input, -left)  
        local i   = #arr  
        while arr[i] do  
            if tmp >= arr[i] then  
                left = left - i  
                break  
            end  
            i = i - 1  
        end  
        cnt = cnt + 1  
    end  
    return cnt  
end 
