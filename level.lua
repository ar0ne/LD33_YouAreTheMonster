LevelScene = Core.class(Sprite)

function LevelScene:init()
	
	self.paused = true
	self.sound = SoundManager.new()
	--self.sounds:add("point", "assets/sounds/sfx_point.mp3")
	
	
	self.bg = Background.new({
		level = self,
		image = "assets/images/background.png",
		bg_scale = conf.LEVEL_BG_SCALE,
		pos_x = conf.WIDTH / 2,
		pos_y = conf.HEIGHT / 2
	})
	
	self:addChild(self.bg)
	
	
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



