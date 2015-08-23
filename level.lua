LevelScene = Core.class(Sprite)

function LevelScene:init()
	
	self.paused = false
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
	
	
	self.hero = Hero.new({
		level = self,
		pos_x = conf.SCREENW / 2,
		pos_y = conf.SCREENH * 2 / 3,
		hero_scale = conf.HERO_SCALE
	})
	
	self:addChild(self.hero)
	
	self.enemys_left = {}
	self.enemys_right = {}
	
	self.score = Score.new({
		level = self,
	})
	
	self:addChild(self.score)
	
	self.clouds = Clouds.new({
		level = self,
		scale_x = conf.CLOUDS_SCALE_X,
		scale_y = conf.CLOUDS_SCALE_Y,
		speed   = conf.CLOUDS_SPEED,
		screen_width = conf.WIDTH,
		alpha = conf.CLOUDS_ALPHA,
	})
	
	self:addChild(self.clouds)
	
	self.stars = Stars.new({
		level = self,
		scale_x = conf.STARS_SCALE_X,
		scale_y = conf.STARS_SCALE_X_SCALE_Y,
		alpha = conf.STARS_ALPHA
	})
		
	self.stars:setVisible(false)
	
	self:addChild(self.stars)	
	
	
	
	
	---- EVENTS ------
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	self:addEventListener(Event.KEY_DOWN, self.onKeyDown, self)
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)

end

function LevelScene:onEnterFrame(event)

	if not self.paused then
		
		if #self.enemys_left < conf.MAX_ENEMY_COUNT then
			local enemy = self:generateRandomEnemies("left")
			self.enemys_left[#self.enemys_left + 1] = enemy
			self:addChild(enemy)
		end
		if #self.enemys_right < conf.MAX_ENEMY_COUNT then
			local enemy = self:generateRandomEnemies("right")
			self.enemys_right[#self.enemys_right + 1] = enemy
			self:addChild(enemy)
		end 
		
	end
end

function LevelScene:onKeyDown(event)
	if event.keyCode == KeyCode.BACK then 
		sceneManager:changeScene("menu", conf.TRANSITION_TIME,  SceneManager.fade)
	end
end

function LevelScene:generateRandomEnemies(direction)
	
	local color = self:_chooseBetweenTwoValue("red", "blue")
	--local direction = self:_chooseBetweenTwoValue("right", "left")
	
	local pos_x
	if direction == "right" then
		pos_x = 100
	else
		pos_x = conf.SCREENW - 100
	end
	
	local enemy = Enemy.new({
		level = self,
		pos_x = pos_x ,
		pos_y = conf.SCREENH * 2 / 3,
		enemy_scale = conf.ENEMY_SCALE,
		direction = direction,
		color = color,
		middle = conf.SCREENW / 2,
		speed = conf.ENEMY_SPEED
	})
	
	return enemy

end

function LevelScene:_chooseBetweenTwoValue(val_1, val_2)

	if math.random(0, 1000) > 500 then
		return val_1
	end
	
	return val_2
end

