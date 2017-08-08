
function DrawItemCell(data, type, x, y, sizeWidth, sizeHeight, butModel ,drawCounts , autoOpenPanel) --绘制物品小图标的方法
	sizeWidth = sizeWidth or 100
	sizeHeight = sizeHeight or 100
	if drawCounts == nil then -- 是否绘制数量
	    drawCounts = true
	end
	if autoOpenPanel == nil then -- 是否打开窗口
		autoOpenPanel = true
	end
	if butModel == nil then 
		butModel = true
	end
	local GUIFunc = GUI.TextureButton
	if not butModel then -- 为false时候只绘制图片，不响应点击
		GUIFunc = GUI.DrawTexture
	end
	if type == ItemType.Item then
		local cfg_item = CFG_item[data.id]
		if cfg_item.type == 6 and cfg_item.itemId == 0 then -- 碎片
			local cfgData = nil
			local assetPath = nil
			if cfg_item.equipId ~= 0 then
				cfgData = CFG_Equip[cfg_item.equipId]
				assetPath = "Texture/Icon/Equip/"..cfgData.icon
			elseif cfg_item.shipEquipId ~= 0 then
				cfgData = CFG_shipEquip[cfg_item.shipEquipId]
				assetPath = "Texture/Icon/ShipEquip/"..cfgData.icon
			elseif cfg_item.sailorId ~= 0 then
				cfgData = CFG_UniqueSailor[cfg_item.sailorId]
				assetPath = "Texture/Character/Header/"..cfgData.resId
			else --主角碎片
				local mHero = mHeroManager.GetHero()
				cfgData = CFG_UniqueSailor[mHero.role]
				assetPath = "Texture/Character/Header/"..cfgData.resId
			end
			--品质背景绘制
			local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot1_"..cfgData.quality)
			GUI.DrawTexture(x, y,sizeWidth,sizeHeight,image) 
			--物品图标绘制
			local image = mAssetManager.GetAsset(assetPath, AssetType.Icon)
			if GUIFunc(x+5, y+5, sizeWidth*0.9, sizeHeight*0.9, image) and butModel then
				if autoOpenPanel then
					mItemViewPanel.SetData(data.id)
					mPanelManager.Show(mItemViewPanel)
				end
				return true
			end
			DrawItemEdging(x, y, sizeWidth, sizeHeight,cfgData.quality)--帧动画
		else -- 正常物品
			local image = mAssetManager.GetAsset("Texture/Icon/Item/"..cfg_item.icon, AssetType.Icon)
			if GUIFunc(x, y, sizeWidth, sizeHeight, image) and butModel then
				if cfg_item.action == 8 and autoOpenPanel then -- 礼包Packag
					mPackageViewPanel.SetData(data.id)
					mPanelManager.Show(mPackageViewPanel)
				elseif autoOpenPanel and cfg_item.AwardList == 'box.csv' then -- 宝箱和食人鱼
					mAwardViewPanel.SetData(1,data.id)
					mPanelManager.Show(mAwardViewPanel)
				elseif autoOpenPanel and cfg_item.AwardList == 'treasureAward.csv' then -- 藏宝图类
				    mAwardViewPanel.SetData(2,data.id)
					mPanelManager.Show(mAwardViewPanel)
				elseif autoOpenPanel then
				    mItemViewPanel.SetData(data.id)
					mPanelManager.Show(mItemViewPanel)
				end
				return true
			end
			DrawItemEdging(x, y, sizeWidth, sizeHeight,cfg_item.quality)--帧动画
		end
		
		if cfg_item.type == 6 then
			local image = mAssetManager.GetAsset("Texture/Gui/Bg/card") -- 标记为碎片
			GUI.DrawTexture(x, y,64,64,image)
		end
		if data.count > 1 and drawCounts then -- 绘制物品数量,保留三位有效数字,小于2不绘制数字
		    -- local content = data.count
		    -- if data.count > 10000 then
				-- content =  data.count / 10000
				-- local spliceNumber = 0
				-- local digit = 1
				-- local pointLeft,pointRight = math.modf(content)
				-- if string.len(pointLeft) >=3 then
				   -- spliceNumber = 0 
				-- elseif string.len(pointLeft) == 1  and  pointRight > 0 then
				   -- digit =  3 
				   -- if string.sub(pointRight,1,digit) == 0 then 
					  -- digit = 1
				   -- end
				   -- spliceNumber = string.sub(pointRight,1,digit)
				-- end
				-- content =  (math.floor(content) + spliceNumber).. '万'
			-- end
			-- if data.count > 100000000 then
				-- content =  data.count / 100000000
				-- local spliceNumber = 0
				-- local digit = 1
				-- local pointLeft,pointRight = math.modf(content)
				-- if string.len(pointLeft) >=3 then
				   -- spliceNumber = 0 
				-- elseif string.len(pointLeft) == 1  and  pointRight > 0 then
				   -- digit =  3 
				   -- if string.sub(pointRight,1,digit) == 0 then 
					  -- digit = 1
				   -- end
				   -- spliceNumber = string.sub(pointRight,1,digit)
				-- end
				-- content =  (math.floor(content) + spliceNumber).. '亿'
			-- end
			-- if cfg_item.type == 6 then -- 碎片以 拥有/合成需要显示
				-- content = content.."/"..cfg_item.count
			-- end
			GUI.Label(x-3, y+sizeHeight-28, sizeWidth, 30, mCommonlyFunc.GetShortNumber(data.count), GUIStyleLabel.Right_25_White, Color.Black)
		end
	elseif type == ItemType.Equip then --装备
		local cfg_Equip = CFG_Equip[data.id]
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot1_"..cfg_Equip.quality)
		GUI.DrawTexture(x, y,sizeWidth, sizeHeight,image)--品质
		
		local image = mAssetManager.GetAsset("Texture/Icon/Equip/"..cfg_Equip.icon, AssetType.Icon)
		if GUIFunc(x+5, y+5, sizeWidth*0.9, sizeHeight*0.9, image) and butModel then--图标icon
			if autoOpenPanel then
				mEquipViewPanel.SetData(nil, data)
				mPanelManager.Show(mEquipViewPanel)
			end
			return true
		end
		DrawItemEdging(x, y, sizeWidth, sizeHeight,cfg_Equip.quality)--帧动画
		if data.sid and data.sid ~= 0 then--是否显示已装备
			local image = mAssetManager.GetAsset("Texture/Gui/Text/wear")
			GUI.DrawTexture(x+5, y,64,64,image)
		end
	elseif type == ItemType.ShipEquip then -- 船装备
		local cfg_Equip = CFG_shipEquip[data.id]
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot1_"..cfg_Equip.quality)
		GUI.DrawTexture(x, y,sizeWidth,sizeHeight,image)
		
		local image = mAssetManager.GetAsset("Texture/Icon/ShipEquip/"..cfg_Equip.icon, AssetType.Icon)
		if GUIFunc(x+5, y+5, sizeWidth*0.9, sizeHeight*0.9, image) and butModel then
			if autoOpenPanel then
				mShipEquipViewPanel.SetData(nil, data)
				mPanelManager.Show(mShipEquipViewPanel)
			end
			return true
		end
		
		DrawItemEdging(x, y, sizeWidth, sizeHeight,cfg_Equip.quality)--帧动画
		
		if data.protect then -- 装备保护锁
			local image = mAssetManager.GetAsset("Texture/Gui/Bg/lock")
			GUI.DrawTexture(x+65, y+5,32,32,image)
		end
		
		if data.sid ~= 0 and data.sid ~= nil then -- 已经装备
			local image = mAssetManager.GetAsset("Texture/Gui/Text/wear")
			GUI.DrawTexture(x+5, y,64,64,image)
		end
	-- elseif type == ItemType.Star then -- 占星技能，暂时不用
		-- local cfg_star = CFG_star[data.id]
		-- local index = math.floor(cfg_star.resId/40)+1
		-- local image = mAssetManager.GetAsset("Texture/Icon/Star/"..index, AssetType.Icon)
		-- GUI.DrawTexture(x,y,sizeWidth,sizeHeight,image,
		-- math.floor(cfg_star.resId/20)%2*(1000/2048)+100/2048*math.floor((os.oldClock*20)%10),
		-- 100/2048*math.floor((cfg_star.resId)%20),
		-- 100/2048,100/2048,0,0,0,0)
		
		-- if GUI.Button(x,y,sizeWidth,sizeHeight, nil, GUIStyleButton.Transparent) then
			-- return true
		-- end
	elseif  type == ItemType.Sailor then
		local cfgData = CFG_UniqueSailor[data.id]
		local assetPath = "Texture/Character/Header/"..cfgData.resId
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot1_"..cfgData.quality)
		GUI.DrawTexture(x, y,sizeWidth,sizeHeight,image) 
		--物品图标绘制
		local image = mAssetManager.GetAsset(assetPath, AssetType.Icon)
		if GUIFunc(x+5, y+5, sizeWidth*0.9, sizeHeight*0.9, image) and butModel then
			if autoOpenPanel then
				sailor = {}
				sailor.index = data.id
				sailor.star = 0
				sailor.exLevel = 0
				sailor.name = cfgData.name
				sailor.quality = cfgData.quality
				sailor.resId = cfgData.resId
				sailor.notExit = true
				mSailorManager.UpdateProperty(sailor)
				mSailorViewPanel.SetData(sailor)
				mPanelManager.Show(mSailorViewPanel)
			end
			return true
		end
		DrawItemEdging(x, y, sizeWidth, sizeHeight,cfgData.quality)--帧动画
	elseif type == nil then -- 空的格子
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot1_0")
		GUI.DrawTexture(x, y,sizeWidth, sizeHeight,image)
	end
end

function DrawItemEdging(x, y, sizeWidth, sizeHeight,quality) --添加高品质装备的序列帧动画,紫，橙，红色
	local textureFiled = nil
	sizeWidth = sizeWidth*1.43
	sizeHeight = sizeHeight*1.43
	x = x - sizeWidth * 0.15
	y = y - sizeHeight * 0.17
	
	-- if	quality == 3 then
	  -- textureFiled = "item_purple"
      -- GUI.FrameAnimation(x+1, y,sizeWidth, sizeHeight,textureFiled,8,0.1)
	-- end
	if	quality == 4 then
	  textureFiled = "item_orange"
	  GUI.FrameAnimation(x, y+2,sizeWidth, sizeHeight,textureFiled,8,0.1)
	end
	if	quality == 5 then
	  textureFiled = "item_red"
	  GUI.FrameAnimation(x, y,sizeWidth, sizeHeight,textureFiled,8,0.1)
	end
end