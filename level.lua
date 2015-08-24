LevelScene = Core.class(Sprite)

local config = conf

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
	self.timeline = Timeline.new(self);
	self.timeline:addLine(1, config.SCREENW * 0.1, config.SCREENH*0.1, timelinewidth, 20, self.onLeftTimeEnd)
	self.timeline:addLine(2, config.SCREENW * 0.9 - timelinewidth, config.SCREENH*0.1, timelinewidth, 20, self.onRightTimeEnd)
	
	
	self.hero = Hero.new({
		level = self,
		pos_x = config.SCREENW / 2,
		pos_y = config.SCREENH * 2 / 3 - 15,
		hero_scale = config.HERO_SCALE
	})
	
	self:addChild(self.hero)
	
	self.enemy_left = nil
	self.enemy_right = nil
	
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
		
	self:addChild(self.stars)	
	self.stars:setVisible(false)
	
	self.crowd_left = Crowd.new({
		level = self,
		scale = config.CROWD_SCALE,
		pos_x = 400,
		pos_y = config.SCREENH * 2 / 3,
	})
	
	self:addChild(self.crowd_left)
	
	self.crowd_right = Crowd.new({
		level = self,
		scale = config.CROWD_SCALE,
		pos_x = config.SCREENW - 400,
		pos_y = config.SCREENH * 2 / 3,
	})
	
	self:addChild(self.crowd_right)

	self.lives = Lives.new(self, {
		goodImage = "assets/images/heart.png",
		badImage = "assets/images/skull.png",
		size = config.SCREENH / 10
	})
	
	self.lives:add("LEFT", {
		X = config.SCREENW * 0.1 + timelinewidth / 2,
		Y = config.SCREENH * 0.2
	})
	
	self.lives:add("RIGHT", {
		X = config.SCREENW * 0.9 - timelinewidth / 2,
		Y = config.SCREENH * 0.2
	})
	
	
	---- EVENTS ------
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	self:addEventListener(Event.KEY_DOWN, self.onKeyDown, self)
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)

end

function _chooseBetweenTwoValue(val_1, val_2)

	if math.random(0, 1000) > 500 then
		return val_1
	end
	
	return val_2
end

function LevelScene.onLeftTimeEnd(timer, self)

	local live_count = self.lives:getLiveCount("LEFT")
	print(live_count)
	if not self.hero.is_demon then
		if live_count >= 1 then
			self.lives:decrement("LEFT")
			timer:start(1, 5)
		elseif live_count < 1 then
			self:switchToMonsterMode()
			self.hero.is_demon = true
		end
	else
		if live_count >= 1 then
			self.lives:decrement("LEFT")
			timer:start(1, 5)
		elseif live_count < 1 then
			sceneManager:changeScene("game_over", conf.TRANSITION_TIME,  SceneManager.fade)
		end
	end
end

function LevelScene.onRightTimeEnd(timer, self)
	local live_count = self.lives:getLiveCount("RIGHT")
	if not self.hero.is_demon then
		if live_count >= 1 then
			self.lives:decrement("RIGHT")
			timer:start(2, 5)
		elseif live_count < 1  then
			self:switchToMonsterMode()
			self.hero.is_demon = true
		end
	else 
		if live_count >= 1 then
			self.lives:decrement("RIGHT")
			timer:start(2, 5)
		elseif live_count < 1  then
			sceneManager:changeScene("game_over", conf.TRANSITION_TIME,  SceneManager.fade)
		end
	end
end

function LevelScene:switchToMonsterMode()
	self.hero.hero_mc:gotoAndPlay(461)
	if self.enemy_left then 
		self:removeChild(self.enemy_left)
	end
	if self.enemy_right then
		self:removeChild(self.enemy_right)
	end
	
	self.enemy_left, self.enemy_right = nil, nil
	
	-- @TODO: сбить счётчики жизней
	self.lives:setType("LEFT", "skull")
	self.lives:setType("RIGHT", "skull")
end

function LevelScene:onEnterFrame(event)

	if not self.paused then
		if not self.enemy_left then
			self.enemy_left = self:generateRandomEnemies("left")
			self:addChild(self.enemy_left)
		end
		if not self.enemy_right then
			self.enemy_right = self:generateRandomEnemies("right")
			self:addChild(self.enemy_right)
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
		------ LEFT TOP ------
		-- режим человека
		if not self.hero.is_demon then
			self.hero.hero_mc:gotoAndPlay(121)
			if self.enemy_left.color == "blue" then
				-- если прав
				self.enemy_left.enemy_mc:gotoAndPlay(81) -- blue fly
				self.enemy_left.enemy_mc:addEventListener(Event.COMPLETE, function() 
					self:removeChild(self.enemy_left)
					self.enemy_left = nil
				end)
			else
				-- если ошибся
				-- ecли жизни есть
				if self.lives:getLiveCount("LEFT") > 1 then
					self.lives:decrement("LEFT")
					self.timeline:start(1, 5)
					self.enemy_left.enemy_mc:gotoAndPlay(181) -- red fly
					self.enemy_left.enemy_mc:addEventListener(Event.COMPLETE, function() 
						self:removeChild(self.enemy_left)
						self.enemy_left = nil
					end)
				else
				-- жизни кончились
					self:switchToMonsterMode()
				end
			end
		else
		-- режим монстра
			self.hero.hero_mc:gotoAndPlay(381)
			if self.enemy_left.color == "red" then
				-- если прав
				self.enemy_left.enemy_mc:gotoAndPlay(181) -- red fly
				self.enemy_left.enemy_mc:addEventListener(Event.COMPLETE, function() 
					self:removeChild(self.enemy_left)
					self.enemy_left = nil
				end)
			else
				-- если ошибся
				-- ecли жизни есть
				if self.lives:getLiveCount("LEFT") > 1 then
					self.lives:decrement("LEFT")
					self.timeline:start(1, 5)
					self.enemy_left.enemy_mc:gotoAndPlay(81) -- blue fly
					self.enemy_left.enemy_mc:addEventListener(Event.COMPLETE, function() 
						self:removeChild(self.enemy_left)
						self.enemy_left = nil
					end)
				else
				-- жизни кончились
					sceneManager:changeScene("game_over", conf.TRANSITION_TIME,  SceneManager.fade)
				end
			end
		end
		
	elseif sX >= -config.SCREENW / 2 and sX <= config.SCREENW / 2  and dX >= -config.SCREENW / 20 and dX <= config.SCREENW / 20 and dY < -config.SCREENH / 3 then
		print("left bottom")
		------ LEFT BOTTOM ------
		-- режим человека
		if not self.hero.is_demon then
			self.hero.hero_mc:gotoAndPlay(121)
			if self.enemy_left.color == "red" then
				-- если прав
				self.enemy_left.enemy_mc:gotoAndPlay(401) -- red fall
				self.enemy_left.enemy_mc:addEventListener(Event.COMPLETE, function() 
					self:removeChild(self.enemy_left)
					self.enemy_left = nil
				end)
			else
				-- если ошибся
				-- ecли жизни есть
				if self.lives:getLiveCount("LEFT") > 1 then
					self.lives:decrement("LEFT")
					self.timeline:start(1, 5)
					self.enemy_left.enemy_mc:gotoAndPlay(521) -- blue fall
					self.enemy_left.enemy_mc:addEventListener(Event.COMPLETE, function() 
						self:removeChild(self.enemy_left)
						self.enemy_left = nil
				end)
				else
				-- жизни кончились
					self:switchToMonsterMode()
				end
			end
		else
		-- режим монстра
			self.hero.hero_mc:gotoAndPlay(381)
			if self.enemy_left.color == "blue" then
				-- если прав
				self.enemy_left.enemy_mc:gotoAndPlay(521) -- blue fall
				self.enemy_left.enemy_mc:addEventListener(Event.COMPLETE, function() 
					self:removeChild(self.enemy_left)
					self.enemy_left = nil
				end)
			else
				-- если ошибся
				-- ecли жизни есть
				if self.lives:getLiveCount("LEFT") > 1 then
					self.lives:decrement("LEFT")
					self.timeline:start(1, 5)
					self.enemy_left.enemy_mc:gotoAndPlay(401) -- red fall
					self.enemy_left.enemy_mc:addEventListener(Event.COMPLETE, function() 
						self:removeChild(self.enemy_left)
						self.enemy_left = nil
					end)
				else
				-- жизни кончились
					sceneManager:changeScene("game_over", conf.TRANSITION_TIME,  SceneManager.fade)
				end
			end
		end
	elseif sX <= config.SCREENW * 1.5 and sX >= config.SCREENW / 2  and dX >= -config.SCREENW / 20 and dX <= config.SCREENW / 20 and dY > config.SCREENH / 3 then
		print("right top")
		------ RIGHT TOP ------
		-- режим человека
		if not self.hero.is_demon then
			self.hero.hero_mc:gotoAndPlay(81)
			if self.enemy_right.color == "red" then
				-- если прав
				self.enemy_right.enemy_mc:gotoAndPlay(181) -- red fly
				self.enemy_right.enemy_mc:addEventListener(Event.COMPLETE, function() 
					self:removeChild(self.enemy_right)
					self.enemy_right = nil
				end)
			else
				-- если ошибся
				-- ecли жизни есть
				if self.lives:getLiveCount("RIGHT") > 1 then
					self.lives:decrement("RIGHT")
					self.timeline:start(1, 5)
					self.enemy_right.enemy_mc:gotoAndPlay(81) -- blue fly
					self.enemy_right.enemy_mc:addEventListener(Event.COMPLETE, function() 
						self:removeChild(self.enemy_right)
						self.enemy_right = nil
					end)
				else
				-- жизни кончились
					self:switchToMonsterMode()
				end
			end
		else
		-- режим монстра
			self.hero.hero_mc:gotoAndPlay(421)
			if self.enemy_right.color == "blue" then
				-- если прав
				self.enemy_right.enemy_mc:gotoAndPlay(81) -- blue fly
				self.enemy_right.enemy_mc:addEventListener(Event.COMPLETE, function() 
					self:removeChild(self.enemy_right)
					self.enemy_right = nil
				end)
			else
				-- если ошибся
				-- ecли жизни есть
				if self.lives:getLiveCount("RIGHT") > 1 then
					self.lives:decrement("RIGHT")
					self.timeline:start(1, 5)
					self.enemy_right.enemy_mc:gotoAndPlay(181) -- red fly
					self.enemy_right.enemy_mc:addEventListener(Event.COMPLETE, function() 
						self:removeChild(self.enemy_right)
						self.enemy_right = nil
					end)
				else
				-- жизни кончились
					sceneManager:changeScene("game_over", conf.TRANSITION_TIME,  SceneManager.fade)
				end
			end
		end
	elseif sX <= config.SCREENW * 1.5 and sX >= config.SCREENW / 2  and dX >= -config.SCREENW / 20 and dX <= config.SCREENW / 20 and dY < -config.SCREENH / 3 then
		print("right bottom")
		------ RIGHT BOTTOM ------
		-- режим человека
		if not self.hero.is_demon then
			self.hero.hero_mc:gotoAndPlay(81)
			if self.enemy_right.color == "blue" then
				-- если прав
				self.enemy_right.enemy_mc:gotoAndPlay(281) -- blue fall
				self.enemy_right.enemy_mc:addEventListener(Event.COMPLETE, function() 
					self:removeChild(self.enemy_right)
					self.enemy_right = nil
				end)
			else
				-- если ошибся
				-- ecли жизни есть
				if self.lives:getLiveCount("RIGHT") > 1 then
					self.lives:decrement("RIGHT")
					self.timeline:start(1, 5)
					self.enemy_right.enemy_mc:gotoAndPlay(401) -- red fall
					self.enemy_right.enemy_mc:addEventListener(Event.COMPLETE, function() 
						self:removeChild(self.enemy_right)
						self.enemy_right = nil
					end)
				else
				-- жизни кончились
					self:switchToMonsterMode()
				end
			end
		else
		-- режим монстра
			self.hero.hero_mc:gotoAndPlay(421)
			if self.enemy_right.color == "red" then
				-- если прав
				self.enemy_right.enemy_mc:gotoAndPlay(401) -- red fall
				self.enemy_right.enemy_mc:addEventListener(Event.COMPLETE, function() 
					self:removeChild(self.enemy_right)
					self.enemy_right = nil
				end)
			else
				-- если ошибся
				-- ecли жизни есть
				if self.lives:getLiveCount("RIGHT") > 1 then
					self.lives:decrement("RIGHT")
					self.timeline:start(1, 5)
					self.enemy_right.enemy_mc:gotoAndPlay(281) -- blue fall
					self.enemy_right.enemy_mc:addEventListener(Event.COMPLETE, function() 
						self:removeChild(self.enemy_right)
						self.enemy_right = nil
					end)
				else
				-- жизни кончились
					sceneManager:changeScene("game_over", conf.TRANSITION_TIME,  SceneManager.fade)
				end
			end
		end
	end
end

function LevelScene:generateRandomEnemies(direction)
	
	local color = _chooseBetweenTwoValue("red", "blue")
	
	local pos_x
	local border
	if direction == "right" then
		pos_x = 200
		border = config.SCREENW / 2 - conf.OFFSET_ENEMY_ATTACK_POSITION
	else
		pos_x = config.SCREENW - 200
		border = config.SCREENW / 2 + conf.OFFSET_ENEMY_ATTACK_POSITION
	end
	
	local enemy = Enemy.new({
		level = self,
		pos_x = pos_x ,
		pos_y = config.SCREENH * 2 / 3,
		enemy_scale = config.ENEMY_SCALE,
		direction = direction,
		color = color,
		border = border,
		speed = config.ENEMY_SPEED,
		start_attack = self.startTimer
	})
	
	return enemy

end

function LevelScene.startTimer(direction, self)
	if direction == "right" then
		--print("Start right timer")
		self.timeline:start(1, 5)
	elseif direction == "left" then
		--print("Start left timer")
		self.timeline:start(2, 5)
	end
end
