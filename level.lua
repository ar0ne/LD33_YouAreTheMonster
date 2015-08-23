LevelScene = Core.class(Sprite)

local config = conf
local en = Enemy

function LevelScene:init()
	
	self.paused = false
	self.camState = 1
	self.sound = SoundManager.new()
	--self.sounds:add("point", "assets/sounds/sfx_point.mp3")
	
	local gest = Gestures.new(self, self.onSwype)
	
	self.bg = Background.new({
		level = self,
		image = "assets/images/level_bg_day.png",
		screen_width = config.SCREENW,
		screen_height = config.SCREENH
	})
	
	self:addChild(self.bg)

	local timelinewidth = config.SCREENW * 0.2
	local timer = Timeline.new(self);
	timer:addLine(1, config.SCREENW * 0.1, config.SCREENH*0.1, timelinewidth, 20, self.onLeftTimeEnd)
	timer:addLine(2, config.SCREENW * 0.9 - timelinewidth, config.SCREENH*0.1, timelinewidth, 20, self.onRightTimeEnd)
	timer:start(1, 1)
	timer:start(2, 1)
	
	
	self.hero = Hero.new({
		level = self,
		pos_x = config.SCREENW / 2,
		pos_y = config.SCREENH * 2 / 3,
		hero_scale = config.HERO_SCALE
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
		scale_x = config.CLOUDS_SCALE_X,
		scale_y = config.CLOUDS_SCALE_Y,
		speed   = config.CLOUDS_SPEED,
		screen_width = config.WIDTH,
        alpha = conf.CLOUDS_ALPHA,
	})
	
	self:addChild(self.clouds)
	
	self.stars = Stars.new({
		level = self,
		scale_x = config.STARS_SCALE_X,
		scale_y = config.STARS_SCALE_X_SCALE_Y,
		alpha = config.STARS_ALPHA
	})
		
	--self:addChild(self.stars)	
	
	
	
	
	---- EVENTS ------
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	self:addEventListener(Event.KEY_DOWN, self.onKeyDown, self)
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)

end

local function _chooseBetweenTwoValue(val_1, val_2)

	if math.random(0, 1000) > 500 then
		return val_1
	end
	
	return val_2
end

function LevelScene.onLeftTimeEnd(timer)
	timer:start(1, 2)
end

function LevelScene.onRightTimeEnd(timer)
	timer:start(2, 2)
end

function LevelScene:onEnterFrame(event)

	if not self.paused then
		if #self.enemys_left < config.MAX_ENEMY_COUNT then
			local enemy = self:generateRandomEnemies("left")
			self.enemys_left[#self.enemys_left + 1] = enemy
			self:addChild(enemy)
		end
		if #self.enemys_right < config.MAX_ENEMY_COUNT then
			local enemy = self:generateRandomEnemies("right")
			self.enemys_right[#self.enemys_right + 1] = enemy
			self:addChild(enemy)
		end 
	end
	
end

function LevelScene:onKeyDown(event)
	if event.keyCode == KeyCode.BACK then 
		sceneManager:changeScene("menu", config.TRANSITION_TIME,  SceneManager.fade)
	end
end

function LevelScene.onSwype (touch, self)
	local sX = touch.startX or 0
	local sY = touch.startY or 0
	local eX = touch.endX or 0
	local eY = touch.endY or 0
	local dX = touch.deltaX	or 0
	local dY = touch.deltaY	or 0
	
	local animate = {}
	local properties = {}
		
	local camS = self.camState
		
	local tween = GTween
		
	if dX >= config.SCREENW / 4 and dY > -config.SCREENH / 7 and dY < config.SCREENH / 7 then
		-- Handle swipe left
		if camS == 0 then
			self.camState = 1
			animate.x = 0
			local tween = tween.new(self, config.CAM_SPEED, animate, properties)
		elseif camS == 1 then
			self.camState = 2
			animate.x = -config.SCREENW / 2
			local tween = tween.new(self, config.CAM_SPEED, animate, properties)
		end
	elseif dX <= -config.SCREENW / 4 and dY > -config.SCREENH / 7 and dY < config.SCREENH / 7 then
		-- Handle swipe right
		if camS == 1 then
			self.camState = 0
			animate.x = config.SCREENW / 2
			local tween = tween.new(self, config.CAM_SPEED, animate, properties)
		elseif camS == 2 then
			self.camState = 1
			animate.x = 0
			local tween = tween.new(self, config.CAM_SPEED, animate, properties)
		end
	elseif sX >= -config.SCREENW / 2 and sX <= config.SCREENW / 2  and dX >= -config.SCREENW / 20 and dX <= config.SCREENW / 20 and dY > config.SCREENH / 3 then
		print("left top")
	elseif sX >= -config.SCREENW / 2 and sX <= config.SCREENW / 2  and dX >= -config.SCREENW / 20 and dX <= config.SCREENW / 20 and dY < -config.SCREENH / 3 then
		print("left bottom")
	elseif sX <= config.SCREENW * 1.5 and sX >= config.SCREENW / 2  and dX >= -config.SCREENW / 20 and dX <= config.SCREENW / 20 and dY > config.SCREENH / 3 then
		print("right top")
	elseif sX <= config.SCREENW * 1.5 and sX >= config.SCREENW / 2  and dX >= -config.SCREENW / 20 and dX <= config.SCREENW / 20 and dY < -config.SCREENH / 3 then
		print("right bottom")
	end
end

function LevelScene:generateRandomEnemies(direction)
	
	local color = _chooseBetweenTwoValue("red", "blue")
	--local direction = self:_chooseBetweenTwoValue("right", "left")
	
	local pos_x
	if direction == "right" then
		pos_x = 100
	else
		pos_x = config.SCREENW - 100
	end
	
	local enemy = en.new({
		level = self,
		pos_x = pos_x ,
		pos_y = config.SCREENH * 2 / 3,
		enemy_scale = config.ENEMY_SCALE,
		direction = direction,
		color = color,
		middle = config.SCREENW / 2,
		speed = config.ENEMY_SPEED
	})
	
	return enemy

end
