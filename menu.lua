MenuScene = Core.class(Sprite)

function MenuScene:init()

	self.bg = Bitmap.new(Texture.new("assets/images/menu_bg.png"))
	
	self.bg:setScale(conf.MENU_BG_SCALE_X, conf.MENU_BG_SCALE_Y)
	self.bg:setAnchorPoint(0.5, 0.5)

	self.bg:setPosition(conf.SCREENW / 2, conf.SCREENH / 2)
	self:addChild(self.bg)

	local start_button_bitmap = Bitmap.new(Texture.new("assets/images/start_button.png"))

	start_button_bitmap:setAnchorPoint(0.5, 0.5)
	start_button_bitmap:setScale(conf.START_BUTTON_SCALE, conf.START_BUTTON_SCALE)
	start_button_bitmap:setPosition(conf.SCREENW / 2, conf.SCREENH * 3 / 4)

	local start_button = Button.new(start_button_bitmap)
	
	self:addChild(start_button)

	start_button:addEventListener("click", function()
		sceneManager:changeScene("level", conf.TRANSITION_TIME,  SceneManager.fade)
	end)
	
	local stars = Stars.new({
		level = self,
		scale_x = conf.STARS_SCALE_X,
		scale_y = conf.STARS_SCALE_X_SCALE_Y,
		alpha = conf.STARS_ALPHA
	})
		
	self:addChild(stars)	
	
	local logo = Bitmap.new(Texture.new("assets/images/Logo.png"))
	
	logo:setAnchorPoint(0.5, 0.5)
	logo:setScale(conf.LOGO_SCALE, conf.LOGO_SCALE)
	logo:setPosition(conf.SCREENW / 2, conf.SCREENH / 2)
	
	self:addChild(logo)
	

	---- EVENTS ----
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	self:addEventListener(Event.KEY_DOWN, self.onKeyDown, self)
end

function MenuScene:onEnterFrame(event)

end

function MenuScene:onKeyDown(event)
	if event.keyCode == KeyCode.BACK then 
		if application:getDeviceInfo() == "Android" then
			application:exit()
		end
	end
end