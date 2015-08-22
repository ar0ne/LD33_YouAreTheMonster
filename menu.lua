MenuScene = Core.class(Sprite)

function MenuScene:init()

	self.bg = Bitmap.new(Texture.new("assets/images/menu_bg.png"))
	
	self.bg:setScale(conf.BG_SCALE, conf.BG_SCALE)
	self.bg:setAnchorPoint(0.5, 0.5)
	print(conf.WIDTH)
	self.bg:setPosition(conf.WIDTH / 2, conf.HEIGHT / 2)
	self:addChild(self.bg)

	local start_button_bitmap = Bitmap.new(Texture.new("assets/images/start_button.png"))
	-- [[
	start_button_bitmap:setAnchorPoint(0.5, 0.5)
	start_button_bitmap:setScale(conf.START_BUTTON_SCALE, conf.START_BUTTON_SCALE)
	start_button_bitmap:setPosition(conf.WIDTH / 2, conf.HEIGHT / 2)
	--]]
	local start_button = Button.new(start_button_bitmap)

	start_button:addEventListener("click", function()
		sceneManager:changeScene("level", conf.TRANSITION_TIME,  SceneManager.fade)
	end)
	

	self:addChild(start_button)

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