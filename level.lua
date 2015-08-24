LevelScene = Core.class(Sprite)

local config = conf

function LevelScene:init()
	
	self.paused = false
	self.camState = 1
	self.sound = SoundManager.new()
	--self.sounds:add("point", "assets/sounds/sfx_point.mp3")
	
	local gest = Gestures.new(self, self.onSwype)
	
	self.bg_day = Background.new({
		level = self,
		image = "assets/images/level_bg_day.png",
		screen_width = config.SCREENW,
		screen_height = config.SCREENH
	})
	
	self.bg_night = Background.new({
		level = self,
		image = "assets/images/level_bg_night.png",
		screen_width = config.SCREENW,
		screen_height = config.SCREENH
	})
	
	self.bg_night:setVisible(false)
	
	self:addChild(self.bg_day)
	self:addChild(self.bg_night)

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
		scale = config.SCORE_SCALE,
		pos_y = 100,
		center_x = conf.SCREENW / 2,
	})
	
	self:addChild(self.score)
	
	self.score:updateScore(0)
	
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
		pos_x = config.SCREENW / 2 - 300,
		pos_y = config.SCREENH * 2 / 3,
	})
	
	self:addChild(self.crowd_left)
	
	self.crowd_right = Crowd.new({
		level = self,
		scale = config.CROWD_SCALE,
		pos_x = config.SCREENW / 2 + 300,
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
	local time
	if not self.hero.is_demon then
		time = conf.LEVEL_HUMAN_TIME
	else
		time = conf.LEVEL_MONSTER_TIME
	end
	
	if not self.hero.is_demon then
		if live_count >= 1 then
			self.lives:decrement("LEFT")
			timer:start(1, time)
		elseif live_count < 1 then
			self:switchToMonsterMode()
		end
	else
		if live_count >= 1 then
			self.lives:decrement("LEFT")
			timer:start(1, time)
		elseif live_count < 1 then
			sceneManager:changeScene("game_over", conf.TRANSITION_TIME,  SceneManager.fade)
		end
	end
end

function LevelScene.onRightTimeEnd(timer, self)

	local live_count = self.lives:getLiveCount("LEFT")
	local time
	if not self.hero.is_demon then
		time = conf.LEVEL_HUMAN_TIME
	else
		time = conf.LEVEL_MONSTER_TIME
	end
	
	local live_count = self.lives:getLiveCount("RIGHT")
	--print("RIGHT: " .. live_count)
	if not self.hero.is_demon then
		if live_count >= 1 then
			self.lives:decrement("RIGHT")
			timer:start(2, time)
		elseif live_count < 1  then
			self:switchToMonsterMode()
		end
	else 
		if live_count >= 1 then
			self.lives:decrement("RIGHT")
			timer:start(2, time)
		elseif live_count < 1  then
			sceneManager:changeScene("game_over", conf.TRANSITION_TIME,  SceneManager.fade)
		end
	end
end

function LevelScene:switchToMonsterMode()
	self.hero.hero_mc:gotoAndPlay(self.hero.goto.hero_transform_to_monster)
	
	self.paused = true
	
	self.hero.hero_mc:addEventListener(Event.COMPLETE, function() 
		self.paused = false
		self.hero.hero_mc:gotoAndPlay(self.hero.goto.monster_wait_left)
	end)
	
	if self.enemy_left then 
		self:removeChild(self.enemy_left)
	end
	if self.enemy_right then
		self:removeChild(self.enemy_right)
	end
	
	self.hero.is_demon = true
	
	self.stars:setVisible(true)
	self.clouds:setVisible(false)
	self.bg_night:setVisible(true)
	self.bg_day:setVisible(false)
	
	self.enemy_left, self.enemy_right = nil, nil
	self.timeline:stop(1)
	self.timeline:stop(2)
	
	-- @TODO: сбить счётчики жизней
	self.lives:setType("LEFT", "skull")
	self.lives:setType("RIGHT", "skull")
end

function LevelScene:onEnterFrame(event)

	if not self.paused then
		-- идёт с права на лево
		if not self.enemy_right then
			self.enemy_right = self:generateRandomEnemies("left")
			self:addChild(self.enemy_right)
		end
		
		-- идёт с лева на право
		if not self.enemy_left then
			self.enemy_left = self:generateRandomEnemies("right")
			self:addChild(self.enemy_left)
		end 
		
	end
	
end

function LevelScene:onKeyDown(event)
	if event.keyCode == KeyCode.BACK then 
		sceneManager:changeScene("menu", config.TRANSITION_TIME,  SceneManager.fade)
	end
end

function LevelScene.onSwype (touch, self)

	if self.paused then
		return
	end

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
		if self.enemy_left.paused then
			return
		end
		self.timeline:stop(1)
		self.enemy_left.paused = true
		if not self.hero.is_demon then
			self.hero.hero_mc:gotoAndPlay(self.hero.goto.hero_fire_left)
			if self.enemy_left.color == "blue" then
				-- если прав
				print("HUMAN LEFT TOP - TRUE")
				self.enemy_left.enemy_mc:gotoAndPlay(self.enemy_left.goto.blue_fly) -- blue fly
				self.enemy_left.enemy_mc:addEventListener(Event.COMPLETE, function() 
					if self.enemy_left then
						self:removeChild(self.enemy_left)
						self.enemy_left = nil
					end
				end)
				self.score:updateScore(self.score:getScore() + 1)
			else
				-- если ошибся
				-- ecли жизни есть
				print("HUMAN LEFT TOP - FALSE")
				if self.lives:getLiveCount("LEFT") > 1 then
					self.lives:decrement("LEFT")
					self.enemy_left.enemy_mc:gotoAndPlay(self.enemy_left.goto.red_fly) -- red fly
					self.enemy_left.enemy_mc:addEventListener(Event.COMPLETE, function() 
						if self.enemy_left then
							self:removeChild(self.enemy_left)
							self.enemy_left = nil
						end
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
				print("MONSTR LEFT TOP - TRUE")
				self.enemy_left.enemy_mc:gotoAndPlay(self.enemy_left.goto.red_fly) -- red fly
				self.enemy_left.enemy_mc:addEventListener(Event.COMPLETE, function() 
					if self.enemy_left then
						self:removeChild(self.enemy_left)
						self.enemy_left = nil
					end
				end)
				self.score:updateScore(self.score:getScore() + 1)
			else
				-- если ошибся
				-- ecли жизни есть
				print("MONSTR LEFT TOP - FALSE")
				if self.lives:getLiveCount("LEFT") > 1 then
					self.lives:decrement("LEFT")
					self.enemy_left.enemy_mc:gotoAndPlay(self.enemy_left.goto.blue_fly) -- blue fly
					self.enemy_left.enemy_mc:addEventListener(Event.COMPLETE, function() 
						if self.enemy_left then
							self:removeChild(self.enemy_left)
							self.enemy_left = nil
						end
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
		if self.enemy_left.paused then
			return
		end
		self.timeline:stop(1)
		self.enemy_left.paused = true
		if not self.hero.is_demon then
			self.hero.hero_mc:gotoAndPlay(self.hero.goto.hero_fire_left)
			if self.enemy_left.color == "red" then
				-- если прав
				self.enemy_left.enemy_mc:gotoAndPlay(self.enemy_left.goto.red_fall) -- red fall
				self.enemy_left.enemy_mc:addEventListener(Event.COMPLETE, function() 
					if self.enemy_left then
						self:removeChild(self.enemy_left)
						self.enemy_left = nil
					end
				end)
				self.score:updateScore(self.score:getScore() + 1)
			else
				-- если ошибся
				-- ecли жизни есть
				if self.lives:getLiveCount("LEFT") > 1 then
					self.lives:decrement("LEFT")
					self.enemy_left.enemy_mc:gotoAndPlay(self.enemy_left.goto.blue_fall) -- blue fall
					self.enemy_left.enemy_mc:addEventListener(Event.COMPLETE, function() 
						if self.enemy_left then
							self:removeChild(self.enemy_left)
							self.enemy_left = nil
						end
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
				self.enemy_left.enemy_mc:gotoAndPlay(self.enemy_left.goto.blue_fall) -- blue fall
				self.enemy_left.enemy_mc:addEventListener(Event.COMPLETE, function() 
					if self.enemy_left then
						self:removeChild(self.enemy_left)
						self.enemy_left = nil
					end
				end)
				self.score:updateScore(self.score:getScore() + 1)
			else
				-- если ошибся
				-- ecли жизни есть
				if self.lives:getLiveCount("LEFT") > 1 then
					self.lives:decrement("LEFT")
					self.enemy_left.enemy_mc:gotoAndPlay(self.enemy_left.goto.red_fall) -- red fall
					self.enemy_left.enemy_mc:addEventListener(Event.COMPLETE, function() 
						if self.enemy_left then
							self:removeChild(self.enemy_left)
							self.enemy_left = nil
						end
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
		if self.enemy_right.paused then
			return
		end
		self.timeline:stop(2)
		self.enemy_right.paused = true
		if not self.hero.is_demon then
			self.hero.hero_mc:gotoAndPlay(self.hero.goto.hero_fire_right)
			if self.enemy_right.color == "blue" then
				-- если прав
				self.enemy_right.enemy_mc:gotoAndPlay(self.enemy_left.goto.blue_fly) -- blue fly
				self.enemy_right.enemy_mc:addEventListener(Event.COMPLETE, function() 
					if self.enemy_right then
						self:removeChild(self.enemy_right)
						self.enemy_right = nil
					end
				end)
				self.score:updateScore(self.score:getScore() + 1)
			else
				-- если ошибся
				-- ecли жизни есть
				if self.lives:getLiveCount("RIGHT") > 1 then
					self.lives:decrement("RIGHT")
					self.enemy_right.enemy_mc:gotoAndPlay(self.enemy_left.goto.red_fly) -- red fly
					self.enemy_right.enemy_mc:addEventListener(Event.COMPLETE, function() 
						if self.enemy_right then
							self:removeChild(self.enemy_right)
							self.enemy_right = nil
						end
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
				self.enemy_right.enemy_mc:gotoAndPlay(self.enemy_left.goto.red_fly) -- red fly
				self.enemy_right.enemy_mc:addEventListener(Event.COMPLETE, function() 
					if self.enemy_right then
						self:removeChild(self.enemy_right)
						self.enemy_right = nil
					end
				end)
				self.score:updateScore(self.score:getScore() + 1)
			else
				-- если ошибся
				-- ecли жизни есть
				if self.lives:getLiveCount("RIGHT") > 1 then
					self.lives:decrement("RIGHT")
					self.enemy_right.enemy_mc:gotoAndPlay(self.enemy_left.goto.blue_fly) -- blue fly
					self.enemy_right.enemy_mc:addEventListener(Event.COMPLETE, function() 
						if self.enemy_right then
							self:removeChild(self.enemy_right)
							self.enemy_right = nil
						end
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
		if self.enemy_right.paused then
			return
		end
		self.timeline:stop(2)
		self.enemy_right.paused = true
		if not self.hero.is_demon then
			self.hero.hero_mc:gotoAndPlay(self.hero.goto.hero_fire_right)
			if self.enemy_right.color == "red" then
				-- если прав
				self.enemy_right.enemy_mc:gotoAndPlay(self.enemy_left.goto.red_fall) -- red fall
				self.enemy_right.enemy_mc:addEventListener(Event.COMPLETE, function() 
					if self.enemy_right then
						self:removeChild(self.enemy_right)
						self.enemy_right = nil
					end
				end)
				self.score:updateScore(self.score:getScore() + 1)
			else
				-- если ошибся
				-- ecли жизни есть
				if self.lives:getLiveCount("RIGHT") > 1 then
					self.lives:decrement("RIGHT")
					self.enemy_right.enemy_mc:gotoAndPlay(self.enemy_left.goto.blue_fall) -- blue fall
					self.enemy_right.enemy_mc:addEventListener(Event.COMPLETE, function() 
						if self.enemy_right then
							self:removeChild(self.enemy_right)
							self.enemy_right = nil
						end
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
				self.enemy_right.enemy_mc:gotoAndPlay(self.enemy_left.goto.blue_fall) -- blue fall
				self.enemy_right.enemy_mc:addEventListener(Event.COMPLETE, function() 
					if self.enemy_right then
						self:removeChild(self.enemy_right)
						self.enemy_right = nil
					end
				end)
				self.score:updateScore(self.score:getScore() + 1)
			else
				-- если ошибся
				-- ecли жизни есть
				if self.lives:getLiveCount("RIGHT") > 1 then
					self.lives:decrement("RIGHT")
					self.enemy_right.enemy_mc:gotoAndPlay(self.enemy_left.goto.red_fall) -- red fall
					self.enemy_right.enemy_mc:addEventListener(Event.COMPLETE, function() 
						if self.enemy_right then
							self:removeChild(self.enemy_right)
							self.enemy_right = nil
						end
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
	-- направление на право, но идёт с левой стороны!
	if direction == "right" then 
		pos_x = 200
		border = config.SCREENW / 2 - conf.OFFSET_ENEMY_ATTACK_POSITION
	elseif direction == "left" then
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
		startTimer = self.startTimer
	})
	
	return enemy

end

function LevelScene.startTimer(direction, self)

	local time
	if not self.hero.is_demon then
		time = conf.LEVEL_HUMAN_TIME
	else
		time = conf.LEVEL_MONSTER_TIME
	end

	if direction == "right" then
		--print("Start right timer")
		--if self.enemy_left then
			self.timeline:start(1, time)
		--end
	elseif direction == "left" then
		--print("Start left timer")
		--if self.enemy_right then
			self.timeline:start(2, time)
		--end
	end
end
