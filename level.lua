LevelScene = Core.class(Sprite)

function LevelScene:init()
	self.camState = 1
	self.paused = true
	self.sound = SoundManager.new()
	--self.sounds:add("point", "assets/sounds/sfx_point.mp3")
	
	local gest = Gestures.new(self, function(touch)
		local sX = touch.startX or 0
		local sY = touch.startY or 0
		local eX = touch.endX or 0
		local eY = touch.endY or 0
		local dX = touch.deltaX	or 0
		local dY = touch.deltaY	or 0
		
		if dX >= conf.SCREENW / 4 and dY > -conf.SCREENH / 7 and dY < conf.SCREENH / 7 then
			-- Handle swipe left
			local animate = {}
			local properties = {}
			if self.camState == 0 then
				self.camState = 1
				animate.x = 0
				local tween = GTween.new(self, conf.CAM_SPEED, animate, properties)
			elseif self.camState == 1 then
				self.camState = 2
				animate.x = -conf.SCREENW / 2
				local tween = GTween.new(self, conf.CAM_SPEED, animate, properties)
			end
		elseif dX <= -conf.SCREENW / 4 and dY > -conf.SCREENH / 7 and dY < conf.SCREENH / 7 then
			-- Handle swipe right
			local animate = {}
			local properties = {}
			if self.camState == 1 then
				self.camState = 0
				animate.x = conf.SCREENW / 2
				local tween = GTween.new(self, conf.CAM_SPEED, animate, properties)
			elseif self.camState == 2 then
				self.camState = 1
				animate.x = 0
				local tween = GTween.new(self, conf.CAM_SPEED, animate, properties)
			end
		elseif sX >= -conf.SCREENW / 2 and sX <= conf.SCREENW / 2  and dX >= -conf.SCREENW / 20 and dX <= conf.SCREENW / 20 and dY > conf.SCREENH / 3 then
			print("left top")
		elseif sX >= -conf.SCREENW / 2 and sX <= conf.SCREENW / 2  and dX >= -conf.SCREENW / 20 and dX <= conf.SCREENW / 20 and dY < -conf.SCREENH / 3 then
			print("left bottom")
		elseif sX <= conf.SCREENW * 1.5 and sX >= conf.SCREENW / 2  and dX >= -conf.SCREENW / 20 and dX <= conf.SCREENW / 20 and dY > conf.SCREENH / 3 then
			print("right top")
		elseif sX <= conf.SCREENW * 1.5 and sX >= conf.SCREENW / 2  and dX >= -conf.SCREENW / 20 and dX <= conf.SCREENW / 20 and dY < -conf.SCREENH / 3 then
			print("right bottom")
		end
	end)
	
	self.bg = Background.new({
		level = self,
		image = "assets/images/level_bg_day.png",
		bg_scale = conf.LEVEL_BG_SCALE,
		screen_width = conf.SCREENW,
		screen_height = conf.SCREENH
		
	})
	
	self:addChild(self.bg)
	
	local screenW = application:getDeviceHeight()
	local screenH = application:getDeviceWidth()
	--[[
	print(screenW, screenH)
	local timelinewidth = screenW * 0.2
	local timeLeft = Timeline.new(self, screenW/10, screenH*0.2, timelinewidth, 20);
	local timeRight = Timeline.new(self, screenW-screenW/10-timelinewidth, screenH*0.2, timelinewidth, 20);
	
	timeLeft:start(1);
	timeLeft:onEnd(function ()
		timeLeft:restart(2)
	end)
	
	timeRight:start(1.01);
	timeRight:onEnd(function ()
		timeRight:restart(2)
	end)
	--]]
	local timelinewidth = screenW * 0.2
	local timer = Timeline.new(self);
	timer:addLine(1, screenW/10, screenH*0.2, timelinewidth, 20, function()
		collectgarbage()
		timer:restart(1, 3)
	end)
	timer:addLine(2, screenW-screenW/10-timelinewidth, screenH*0.2, timelinewidth, 20, function()
		collectgarbage()
		timer:restart(2, 3)
	end)
	timer:start(1, 1)
	timer:start(2, 1)
	
	
	---- EVENTS ------
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	self:addEventListener(Event.KEY_DOWN, self.onKeyDown, self)
	--self.world:addEventListener(Event.BEGIN_CONTACT, self.onBeginContact, self)
end

function LevelScene:onEnterFrame(event)

	if not self.paused then
				 
	end
end

function LevelScene:onKeyDown(event)
	if event.keyCode == KeyCode.BACK then 
		sceneManager:changeScene("menu", conf.TRANSITION_TIME,  SceneManager.fade)
	end
end


