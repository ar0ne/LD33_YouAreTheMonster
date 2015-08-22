LevelScene = Core.class(Sprite)

function LevelScene:init()
	
	self.paused = true
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
	for i = 1, 5 do 
		self.enemys[i] = Enemy.new({
			level = self,
			pos_x = 100 + i * 50 ,
			pos_y = conf.HEIGHT * 2 / 3,
			enemy_scale = conf.ENEMY_SCALE,
			direction = "right"
		})
		self:addChild(self.enemys[i])
	end
	
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
				 
	end
end

function LevelScene:onKeyDown(event)
	if event.keyCode == KeyCode.BACK then 
		sceneManager:changeScene("menu", conf.TRANSITION_TIME,  SceneManager.fade)
	end
end



