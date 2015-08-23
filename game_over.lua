GameOver = Core.class(Sprite)

function GameOver:init(last_score)
		
	local bg = Bitmap.new(Texture.new("assets/images/game_over_bg.png"))
	
	bg:setScale(conf.GAMEOVER_BG_SCALE_X, conf.GAMEOVER_BG_SCALE_Y)
	bg:setAnchorPoint(0.5, 0.5)

	bg:setPosition(conf.SCREENW / 2, conf.SCREENH / 2)
	self:addChild(bg)
	
	
	local retry_button_bitmap = Bitmap.new(Texture.new("assets/images/retry_button.png"))
	-- [[
	retry_button_bitmap:setAnchorPoint(0.5, 0.5)
	retry_button_bitmap:setScale(conf.RETRY_BUTTON_SCALE, conf.RETRY_BUTTON_SCALE)
	retry_button_bitmap:setPosition(conf.SCREENW / 2, conf.SCREENH * 5 / 6)
	--]]
	local retry_button = Button.new(retry_button_bitmap)

	retry_button:addEventListener("click", function()
		sceneManager:changeScene("level", conf.TRANSITION_TIME,  SceneManager.fade, easing.outBounce)
	end)
	
	self:addChild(retry_button)
	
	if last_score then
		print("Your last_score = " .. last_score)
	end
	
end

