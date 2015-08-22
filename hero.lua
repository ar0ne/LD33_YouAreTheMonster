Hero = Core.class(Sprite)

--[[
	level
	pos_x
	pos_y
	hero_scale
--]]

function Hero:init(options)
	
	self.level = options.level
	self.paused = true
	self.isAttack = false
	
	local animation = {
		Bitmap.new(Texture.new("assets/images/Lead-character-static.png")),
		Bitmap.new(Texture.new("assets/images/Lead-character-gunner.png")),
		Bitmap.new(Texture.new("assets/images/Lead-character-fire.png")),
	}
	
	for i = 1, #animation do
		animation[i]:setScale(options.hero_scale)
		animation[i]:setAnchorPoint(0.5, 0.5)
	end
	
	self.hero_mc = MovieClip.new{
		{1, 20, animation[1]},
		{21, 40, animation[2]},
		{41, 60, animation[3]}
	}
	
	self.hero_mc:setGotoAction(20, 1) -- wait 
	self.hero_mc:setGotoAction(60, 21) -- fire
	
	self.hero_mc:gotoAndPlay(21) -- ставлю атаку пока wait
	
	self:addChild(self.hero_mc)
	
	self:setPosition(options.pos_x, options.pos_y)
	
end

--function Hero: