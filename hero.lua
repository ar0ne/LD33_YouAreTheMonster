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
	
	local hero_wait_spritesheet = Texture.new("assets/images/Hero_wait.png")
	local hero_fire_spritesheet = Texture.new("assets/images/Hero_fire.png")
	
	local animation = {
		Bitmap.new(TextureRegion.new(hero_wait_spritesheet, 0, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(hero_wait_spritesheet, 50, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(hero_fire_spritesheet, 0, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(hero_fire_spritesheet, 50, 0, 50, 50)),
	}
	
	for i = 1, #animation do
		animation[i]:setScale(options.hero_scale)
		animation[i]:setAnchorPoint(0.5, 0.5)
	end
	
	self.hero_mc = MovieClip.new{
		-- wait right
		{1,  20, animation[1], {scaleX = options.hero_scale }},
		{21, 40, animation[2], {scaleX = options.hero_scale }},
		-- wait left
		{41, 60, animation[1], {scaleX = -options.hero_scale }},
		{61, 80, animation[2], {scaleX = -options.hero_scale }},
		-- fire right
		{81,  100, animation[3], {scaleX = options.hero_scale }},
		{101, 120, animation[4], {scaleX = options.hero_scale }},
		-- fire left
		{121, 140, animation[3], {scaleX = -options.hero_scale }},
		{141, 160, animation[4], {scaleX = -options.hero_scale}}
	}
	
	self.hero_mc:setGotoAction(40, 	1)  -- wait right
	self.hero_mc:setGotoAction(80, 	41)  -- wait left
	self.hero_mc:setGotoAction(120, 81)  -- fire right
	self.hero_mc:setGotoAction(160, 121) -- fire left
	
	self.hero_mc:gotoAndPlay(1)
	
	self:addChild(self.hero_mc)
	
	self:setPosition(options.pos_x, options.pos_y)
	
end

--function Hero: