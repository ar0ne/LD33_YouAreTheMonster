LevelScene = Core.class(Sprite)

function LevelScene:init()
	
	self.paused = false
	self.sound = SoundManager.new()
	--self.sounds:add("point", "assets/sounds/sfx_point.mp3")
	
	
	self.bg = Background.new({
		level = self,
		image = "assets/images/level_bg.png",
		bg_scale = conf.LEVEL_BG_SCALE,
		pos_x = conf.WIDTH / 2,
		pos_y = conf.HEIGHT / 2
	})
	
	self:addChild(self.bg)
	
	
	self.hero = Hero.new({
		level = self,
		pos_x = conf.WIDTH / 2,
		pos_y = conf.HEIGHT * 2 / 3,
		hero_scale = conf.HERO_SCALE
	})
	
	self:addChild(self.hero)
	
	self.enemys = {}
	
	local screenW = application:getDeviceHeight()
	local screenH = application:getDeviceWidth()
	local timelinewidth = screenW * 0.2
	local timeLeft = Timeline.new(stage, screenW/10, screenH*0.2, timelinewidth, 20);
	local timeRight = Timeline.new(stage, screenW-screenW/10-timelinewidth, screenH*0.2, timelinewidth, 20);
	
	timeLeft:start(1);
	timeLeft:onEnd(function ()
		timeLeft:restart(2)
	end)
	
	timeRight:start(1.000000000000001);
	timeRight:onEnd(function ()
		timeRight:restart(2)
	end)
	
	
	---- EVENTS ------
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	self:addEventListener(Event.KEY_DOWN, self.onKeyDown, self)

end

function LevelScene:onEnterFrame(event)

	if not self.paused then
		self:generateRandomEnemies()
	end
end

function LevelScene:onKeyDown(event)
	if event.keyCode == KeyCode.BACK then 
		sceneManager:changeScene("menu", conf.TRANSITION_TIME,  SceneManager.fade)
	end
end

function LevelScene:generateRandomEnemies()
	
	local color = self:_chooseBetweenTwoValue("red", "blue")
	local direction = self:_chooseBetweenTwoValue("right", "left")
	
	local pos_x
	if direction == "right" then
		pos_x = 100
	else
		pos_x = conf.WIDTH - 100
	end
	
	local enemy = Enemy.new({
		level = self,
		pos_x = pos_x ,
		pos_y = conf.HEIGHT * 2 / 3,
		enemy_scale = conf.ENEMY_SCALE,
		direction = direction,
		color = color,
		middle = conf.WIDTH / 2,
		speed = math.random(conf.MIN_ENEMY_SPEED, conf.MAX_ENEMY_SPEED)
	})
	self:addChild(enemy)
	

end

function LevelScene:_chooseBetweenTwoValue(val_1, val_2)

	if math.random(0, 1000) > 500 then
		return val_1
	end
	
	return val_2
end


