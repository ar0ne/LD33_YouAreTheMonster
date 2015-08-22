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
		{1, 20, animation[1]},
		{21, 40, animation[2]},
		{41, 60, animation[3]},
		{61, 80, animation[4]}
	}
	
	self.hero_mc:setGotoAction(40, 1) -- wait 
	self.hero_mc:setGotoAction(80, 41) -- fire
	
	self.hero_mc:gotoAndPlay(1)
	
	self:addChild(self.hero_mc)
	
	self:setPosition(options.pos_x, options.pos_y)
	
end

--function Hero: