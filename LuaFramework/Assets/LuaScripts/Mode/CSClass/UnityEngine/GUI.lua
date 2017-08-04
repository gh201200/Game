local mAudioManager = nil
local mGUIStyleManager  = nil
GUI = {}


local IsTransparentButton = function(style)
	if style == GUIStyleButton.Transparent or style == GUIStyleButton.Transparent_Art or 
		style == GUIStyleButton.Transparent_30_Brown_Art or style == GUIStyleButton.Transparent_40_Art then
		return true
	end
end

GUI.UnHorizontalRestX = function(value)
	return (value-GUI.offsetX)/GUI.modulus
end

GUI.UnVerticalRestY = function(value)
	return (value-GUI.offsetY)/GUI.modulus
end

GUI.UnHorizontalWidth = function(value)
	return value/GUI.modulus
end

GUI.UnHorizontalHeight = function(value)
	return value/GUI.modulus
end

GUI.HorizontalRestX = function(value)
	return value*GUI.modulus + GUI.offsetX
end

GUI.VerticalRestY = function(value)
	return value*GUI.modulus + GUI.offsetY
end

GUI.HorizontalRestWidth = function(value)
	return value*GUI.modulus
end

GUI.VerticalRestHeight = function(value)
	return value*GUI.modulus
end

GUI.RestSize = function(x, y, width, height)
	return 	x*GUI.modulus + GUI.offsetX, 
			y*GUI.modulus + GUI.offsetY, 
			width*GUI.modulus, 
			height*GUI.modulus
end

GUI.Init = function()
	local defaultScale = Screen.DefaultHeight/Screen.DefaultWidth
	local scale = Screen.height/Screen.width
	
	if defaultScale == scale then
		GUI.modulus = Screen.height / Screen.DefaultHeight
		GUI.offsetX = 0
		GUI.offsetY = 0
	elseif defaultScale > scale then
		GUI.modulus = Screen.height / Screen.DefaultHeight
		GUI.offsetX = math.abs(Screen.width-Screen.DefaultWidth*GUI.modulus) / 2
		GUI.offsetY = 0
	elseif defaultScale < scale then
		GUI.modulus = Screen.width / Screen.DefaultWidth
		GUI.offsetX = 0
		GUI.offsetY = math.abs(Screen.height-Screen.DefaultHeight*GUI.modulus) / 2
		-- print(1-GUI.modulus)
	end
	GUI._offsetX = GUI.offsetX
	GUI._offsetY = GUI.offsetY
end

--零坐标在左下角
-- source_x, source_y, source_width, source_height 为0~1
-- leftBorder, rightBorder, topBorder, bottomBorder 为0~width
GUI.DrawTexture = function(x, y, width, height, texture, source_x, source_y, source_width, source_height,
		leftBorder, rightBorder, topBorder, bottomBorder, color)
	if not texture or not GUI.EventRepaint then
		return
	end
	x, y, width, height = GUI.RestSize(x, y, width, height)
	if source_x then
		-- GUI.Views[1] = x
		-- GUI.Views[2] = y
		-- GUI.Views[3] = width
		-- GUI.Views[4] = height
		-- GUI.Views[5] = scrollPositionX
		-- GUI.Views[5] = scrollPositionY
	
		if  GUI.Views[1] ~= 0 then
			if y < GUI.Views[6] then
				local yy = GUI.Views[6] - y
				source_y = source_y + source_height*yy/height
				source_height = source_height*(height-yy)/height
				height = height - yy
				y = GUI.Views[6]
			end
			
			if height + y - GUI.Views[6]  > GUI.Views[4] then
				local yy = height + y - GUI.Views[6] - GUI.Views[4]
				source_height = source_height*(height-yy)/height
				-- source_y = source_y*(height-yy)/height
				height = height - yy
			end
		end
		
	
		if color then
			GUI.CSDrawTextureFunc_3(x, y, width, height, texture, source_x, 1-source_y-source_height, source_width, source_height,
				leftBorder, rightBorder, topBorder, bottomBorder, color)
		else
			GUI.CSDrawTextureFunc_2(x, y, width, height, texture, source_x, 1-source_y-source_height, source_width, source_height,
				leftBorder, rightBorder, topBorder, bottomBorder)
		end
	else
		return GUI.CSDrawTextureFunc_1(x, y, width, height, texture)
	end
end

--1136X640图片不模糊绘制方法   需专成1024X1024资源
GUI.DrawPackerTexture = function(image, color)
	if color then
		GUI.DrawTexture(0,0,1024,640,image,0,0,1,640/1024,0,0,0,0,color)
		GUI.DrawTexture(1024,0,256,256,image,0,700/1024,0.25,0.25,0,0,0,0,color)
		GUI.DrawTexture(1024,256,256,256,image,0.25,700/1024,0.25,0.25,0,0,0,0,color)
		GUI.DrawTexture(1024,512,256,256,image,0.5,700/1024,0.25,0.25,0,0,0,0,color)
	else
		GUI.DrawTexture(0,0,1024,640,image,0,0,1,640/1024)
		GUI.DrawTexture(1024,0,256,256,image,0,700/1024,0.25,0.25)
		GUI.DrawTexture(1024,256,256,256,image,0.25,700/1024,0.25,0.25)
		GUI.DrawTexture(1024,512,256,256,image,0.5,700/1024,0.25,0.25)
	end
end

GUI.UnScaleDrawTexture = function(x, y, width, height, texture, source_x, source_y, source_width, source_height,
		leftBorder, rightBorder, topBorder, bottomBorder, color)
	if not texture or not GUI.EventRepaint then
		return
	end
	if source_x then
		if color then
			GUI.CSDrawTextureFunc_3(x, y, width, height, texture, source_x, source_y, source_width, source_height,
				leftBorder, rightBorder, topBorder, bottomBorder, color)
		else
			GUI.CSDrawTextureFunc_2(x, y, width, height, texture, source_x, source_y, source_width, source_height,
				leftBorder, rightBorder, topBorder, bottomBorder)
		end
	else
		return GUI.CSDrawTextureFunc_1(x, y, width, height, texture)
	end
end

GUI.Label = function(x, y, width, height, str, style, outColor, outlineWidth, notRestSize)
	if not str or not GUI.EventRepaint then
		return
	end
	if not notRestSize then
		x, y, width, height = GUI.RestSize(x, y, width, height)
	end
	-- if not Event.GetCurrent().type:Equals(UnityEventType.Repaint) then
		-- return
	-- end
	
	mGUIStyleManager = mGUIStyleManager or require "LuaScript.Control.GUIStyleManager"
	style = style or GUIStyleLabel.Left_35_Black
	local csStyle = mGUIStyleManager.GetGUIStyle(style)
	local csOutStyle = nil
	if outColor then
		csOutStyle = mGUIStyleManager.GetGUIStyle(style, nil, outColor)
	end
	
	if outColor then
		if not outlineWidth then
			outlineWidth = ConstValue.DefaultOutlineWidth
		end
		
		GUI.CSLabelFunc_1(x, y, width, height, ReplaceColor(str), csStyle, csOutStyle, outlineWidth)
		GUI.CSLabelFunc_2(x, y, width, height, str, csStyle)
	else
		GUI.CSLabelFunc_2(x, y, width, height, str, csStyle)
	end
end

GUI.UnScaleLabel = function(x, y, width, height, str, style, outColor, outlineWidth)
	GUI.Label(x, y, width, height, str, style, outColor, outlineWidth, true)
end

GUI.Button = function(x, y, width, height, str, style)
	str = str or Language[164]
	
	mGUIStyleManager = mGUIStyleManager or require "LuaScript.Control.GUIStyleManager"
	
	-- print(1)
	local csStyle =  mGUIStyleManager.GetGUIStyle(style)
	-- print(2)
	
	x, y, width, height = GUI.RestSize(x, y, width, height)
	local click = GUI.CSButtonFunc_2(x, y, width, height, str, csStyle) and
		CsCurrentEventEqualsType(UnityEventType.Used) 
	if click and not IsTransparentButton(style) then
		mAudioManager = mAudioManager or require "LuaScript.Control.System.AudioManager"
		mAudioManager.PlayAudioOneShot(AudioData.click)
		GUI.ScrollSpeed = nil
	end
	return click
end

GUI.UnScaleButton = function(x, y, width, height, str, style)
	str = str or Language[164]
	
	mGUIStyleManager = mGUIStyleManager or require "LuaScript.Control.GUIStyleManager"
	local csStyle =  mGUIStyleManager.GetGUIStyle(style)
	local click = GUI.CSButtonFunc_2(x, y, width, height, str, csStyle) and
		CsCurrentEventEqualsType(UnityEventType.Used) 
	if click and not IsTransparentButton(style) then
		mAudioManager = mAudioManager or require "LuaScript.Control.System.AudioManager"
		mAudioManager.PlayAudioOneShot(AudioData.click)
		GUI.ScrollSpeed = nil
	end
	return click
end

--零坐标在左下角
GUI.TextureButton = function(x, y, width, height, texture, source_x, source_y, source_width, source_height,
		leftBorder, rightBorder, topBorder, bottomBorder)
	if texture then
		GUI.DrawTexture(x, y, width, height, texture, source_x, source_y, source_width, source_height,
			leftBorder, rightBorder, topBorder, bottomBorder)
	end
	-- x, y, width, height = GUI.RestSize(x, y, width, height)
	return GUI.Button(x, y, width, height, nil, GUIStyleButton.Transparent)
end

GUI.UnScaleTextureButton = function(x, y, width, height, texture, source_x, source_y, source_width, source_height,
		leftBorder, rightBorder, topBorder, bottomBorder)
	if texture then
		GUI.UnScaleDrawTexture(x, y, width, height, texture, source_x, source_y, source_width, source_height,
			leftBorder, rightBorder, topBorder, bottomBorder)
	end
	-- x, y, width, height = GUI.RestSize(x, y, width, height)
	return GUI.UnScaleButton(x, y, width, height, nil, GUIStyleButton.Transparent)
end

GUI.TextField = function(x, y, width, height, str, style)
	-- GUI.SetNextControlName("TextInput")
	x, y, width, height = GUI.RestSize(x, y, width, height)
	mGUIStyleManager = mGUIStyleManager or require "LuaScript.Control.GUIStyleManager"
	local csStyle = mGUIStyleManager.GetGUIStyle(style)
	
	if GUI.xxx and not GUI.xxx2 then
		local str = "TextField error !!!\n"
		str = str .. string.format("x = %f y = %f width = %f height = %f \n", GUI.xxxTable[1], GUI.xxxTable[2], GUI.xxxTable[3], GUI.xxxTable[4])
		str = str .. tostring(GUI.xxxTable[5]) .. "\n"
		str = str .. tostring(GUI.xxxTable[6]) .. "\n"
		str = str .. debug.traceback() .. "\n"
		UploadError(str)
		GUI.xxx2 = true
	end
	GUI.xxxTable = {x, y, width, height, str, style}
	
	GUI.xxx = true
	local mStr = GUI.CSTextFieldFunc(x, y, width, height, str, csStyle)
	GUI.xxx = false
	return mStr
end

GUI.TextArea = GUI.TextField


GUI.PasswordField = function(x, y, width, height, str, style)
	x, y, width, height = GUI.RestSize(x, y, width, height)
	mGUIStyleManager = mGUIStyleManager or require "LuaScript.Control.GUIStyleManager"
	local csStyle = mGUIStyleManager.GetGUIStyle(style)
	return GUI.CSPasswordFieldFunc(x, y, width, height, str, "*", csStyle)
end

GUI.HorizontalSlider = function(x, y, width, height, value, leftValue, rightValue, sliderStyle, thumbStyle)
	x, y, width, height = GUI.RestSize(x, y, width, height)

	mGUIStyleManager = mGUIStyleManager or require "LuaScript.Control.GUIStyleManager"
	local csSliderStyle = mGUIStyleManager.GetGUIStyle(sliderStyle)
	local csThumbStyle = mGUIStyleManager.GetGUIStyle(thumbStyle)
	
	if rightValue == 0 then
		GUI.CSHorizontalSliderFunc(x, y, width, height, value, leftValue, 1, csSliderStyle, csThumbStyle)
		return 0
	else
		return GUI.CSHorizontalSliderFunc(x, y, width, height, value, leftValue, rightValue, csSliderStyle, csThumbStyle)
	end
end

GUI.Views = {0,0}
GUI.ScrollSpeed = nil
GUI.BeginScrollView = function(x, y, width, height, scrollPositionX, scrollPositionY, viewRect_x, viewRect_y, viewRect_width, viewRect_height)
	x, y, width, height = GUI.RestSize(x, y, width, height)
	
	viewRect_x, viewRect_y, viewRect_width, viewRect_height = GUI.RestSize(viewRect_x, viewRect_y, viewRect_width, viewRect_height)
	GUI.Views[1] = x
	GUI.Views[2] = y
	GUI.Views[3] = width
	GUI.Views[4] = height
	GUI.Views[5] = scrollPositionX
	GUI.Views[6] = scrollPositionY
	
	
	mPanelManager = mPanelManager or  require "LuaScript.Control.PanelManager"
	if Input.GetTouchCount() > 0 and GUI.GetEnabled() then

		local toucheX,toucheY,deltaX,deltaY = 0,0,0,0
		if CsGetTouchInfo then
			toucheX,toucheY,deltaX,deltaY = CsGetTouchInfo(0)
		else
			local touche = Input.GetTouch(0)
			local position = touche.position
			local deltaPosition = touche.deltaPosition
			if not CsIsNull(deltaPosition) then
				toucheX,toucheY = position.x, position.y
				deltaX,deltaY = deltaPosition.x, deltaPosition.y
			end
		end
		toucheY = Screen.height - toucheY
		
		if WindowsEditor or WindowsPlayer or IPhonePlayer then
			deltaX = deltaX * 0.4
			deltaY = deltaY * 0.4
		end
		
		-- print(toucheX,toucheY,deltaX,deltaY)
		-- print(GUI.Views[1], GUI.Views[2], width, height)
		if GUI.Views[1] < toucheX and GUI.Views[1] + width > toucheX and
			GUI.Views[2] < toucheY and GUI.Views[2] + height > toucheY then
			scrollPositionX = scrollPositionX - deltaX
			scrollPositionY = scrollPositionY + deltaY
		end
	end
	local x,y = GUI.CSBeginScrollViewFunc2(x, y, width, height, scrollPositionX, scrollPositionY, viewRect_x, viewRect_y, viewRect_width, viewRect_height)
	
	return x,y,y+10>viewRect_height-height
end

GUI.EndScrollView = function()
	GUI.Views[1] = 0
	GUI.Views[2] = 0
	GUI.CSEndScrollViewFunc()
end

GUI.BeginGroup = function(x, y, width, height)
	x, y, width, height = GUI.RestSize(x, y, width, height)
	GUI.offsetX = 0
	GUI.offsetY = 0

	return GUI.CSBeginGroupFunc(x, y, width, height)
end

GUI.UnScaleBeginGroup = function(x, y, width, height)
	GUI.offsetX = 0
	GUI.offsetY = 0
	
	return GUI.CSBeginGroupFunc(x, y, width, height)
end

GUI.EndGroup = function()
	GUI.offsetX = GUI._offsetX
	GUI.offsetY = GUI._offsetY
	GUI.CSEndGroupFunc()
end

GUI.SetColor = function(sc_Color)
	GUI.CSSetColorFunc(sc_Color)
end

GUI.HideScrollbar = function()
	-- print("HideScrollbar")
	-- local CSGUI = CsFindType("UnityEngine.GUI")
	local csGUISkin = UnityEngine.GUI.skin
	csGUISkin.verticalScrollbar = nil
	csGUISkin.verticalScrollbarThumb = nil
	csGUISkin.horizontalScrollbar = nil
	csGUISkin.horizontalScrollbarThumb = nil
end

GUI.SetEnabled = function(value)
	-- print(value)
	GUI.enabled = value
	GUI.CSSetEnabledFunc(value)
end

GUI.GetEnabled = function(value)
	if GUI.enabled == nil then
		return true
	end
	return GUI.enabled
end

GUI.FocusControl = function(value)
	-- local cs_Args = NewObjectArr(value)
	GUI.CSFocusControlFunc(value)
end

GUI.GetTextHeight = function(str, width, style)
	mGUIStyleManager = mGUIStyleManager or require "LuaScript.Control.GUIStyleManager"
	local csStyle = mGUIStyleManager.GetGUIStyle(style)
	-- GUIContent.example.text = str
	
	width = GUI.HorizontalRestWidth(width)
	-- return csStyle:CalcHeight(GUIContent.example, width)
	
	return GUI.UnHorizontalHeight(GUI.CSCalcHeightFunc(csStyle, str, width))
end

-- GUI.FrameAnimation(x, y, width, height,image, )
	-- local index = math.floor(cfg_star.resId/40)+1
	-- local image = mAssetManager.GetAsset("Texture/Icon/Star/"..index, AssetType.Icon)
		-- GUI.DrawTexture(x,y,sizeWidth,sizeHeight,image,
		-- math.floor(cfg_star.resId/20)%2*(1000/2048)+100/2048*math.floor((os.oldClock*20)%10),
		-- 100/2048*math.floor((cfg_star.resId)%20),
		-- 100/2048,100/2048,0,0,0,0)
	

GUI.GetTextSize = function(str, style)
	mGUIStyleManager = mGUIStyleManager or require "LuaScript.Control.GUIStyleManager"
	local csStyle = mGUIStyleManager.GetGUIStyle(style)
	-- GUIContent.example.text = str
	local width,height = GUI.CSCalcSizeFunc(csStyle, str)
	return GUI.UnHorizontalWidth(width), GUI.UnHorizontalHeight(height)
end
--循环播放的序列帧animation
local os = os
GUI.FrameAnimation = function ( x ,y ,width,height,folderNum,textureNum,gap) -- rect，animation下文件夹名，图片数量，图片间隔
	if not folderNum then
		print('序列帧图片所在文件夹路径未设置')
		return
    end 
	if	not textureNum then
	    textureNum = 10	
    end
	if	not gap then
	    gap = 0.1	
    end
	local qi = os.clock()
    local mAssetManager = require "LuaScript.Control.AssetManager"
	local textureFolder = "Texture/Gui/Animation/"..folderNum--路径
	local texturePath,tNum,tCount,tIndex--path,每秒张数，语句执行几次切换一次图片，图片下标
	tIndex = math.floor((qi%(textureNum*gap))/gap) + 1  
	if tIndex > textureNum then
	   tIndex = textureNum
	end
	texturePath = textureFolder .. '/' .. tIndex
	local image = mAssetManager.GetAsset(texturePath)
	GUI.DrawTexture(x ,y ,width,height,image)
end
--只播放一定时间last的的序列帧animation
GUI.FrameAnimation_Once = function ( x ,y ,width,height,folderNum,setclock,textureNum,gap,last) -- rect，animation下文件夹名，写入开始播放的时间，图片数量，图片间隔,持续播放时间
	if not folderNum then
		print('序列帧图片所在文件夹路径未设置')
		return
    end 
	if not setclock then
		print('未写入序列帧动画开始播放的时间')
		return
    end 
	if	not textureNum then
	    textureNum = 10	
    end
	if	not gap then
	    gap = 0.1	
    end
	if not last then -- 默认播放时间为一轮
		last = textureNum*gap
	end
    local mAssetManager = require "LuaScript.Control.AssetManager"
	local textureFolder = "Texture/Gui/Animation/"..folderNum--路径
	local texturePath,tNum,tCount,tIndex--path,每秒张数，语句执行几次切换一次图片，图片下标
	local now = os.clock()

	if now - setclock > last or (now - setclock) < 0 then
	   return
	end
	
	tIndex =  math.floor((now - setclock)/gap)
	tIndex = (tIndex % textureNum) + 1
	texturePath = textureFolder .. '/' .. tIndex
	local image = mAssetManager.GetAsset(texturePath)
	GUI.DrawTexture(x ,y ,width,height,image)
end