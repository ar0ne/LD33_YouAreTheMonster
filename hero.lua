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
	self.is_attack = false
	self.is_demon = false
	
	local hero_wait_spritesheet = Texture.new("assets/images/Hero_wait.png")
	local hero_fire_spritesheet = Texture.new("assets/images/Hero_fire.png")
	local hero_transform_pack = TexturePack.new("assets/images/Hero_transform.txt", "assets/images/Hero_transform.png", true)
	
	local animation = {
		Bitmap.new(TextureRegion.new(hero_wait_spritesheet, 0, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(hero_wait_spritesheet, 50, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(hero_fire_spritesheet, 0, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(hero_fire_spritesheet, 50, 0, 50, 50)),
		
		Bitmap.new(hero_transform_pack:getTextureRegion("01.png")),
		Bitmap.new(hero_transform_pack:getTextureRegion("02.png")),
		Bitmap.new(hero_transform_pack:getTextureRegion("03.png")),
		Bitmap.new(hero_transform_pack:getTextureRegion("04.png")),
		Bitmap.new(hero_transform_pack:getTextureRegion("05.png")),
		Bitmap.new(hero_transform_pack:getTextureRegion("06.png")),
		Bitmap.new(hero_transform_pack:getTextureRegion("07.png")),
		Bitmap.new(hero_transform_pack:getTextureRegion("08.png")),
		Bitmap.new(hero_transform_pack:getTextureRegion("09.png")),
		Bitmap.new(hero_transform_pack:getTextureRegion("10.png")),
		Bitmap.new(hero_transform_pack:getTextureRegion("11.png")),
		Bitmap.new(hero_transform_pack:getTextureRegion("12.png")),
		Bitmap.new(hero_transform_pack:getTextureRegion("13.png")),
		Bitmap.new(hero_transform_pack:getTextureRegion("14.png")),
		Bitmap.new(hero_transform_pack:getTextureRegion("15.png")),
		Bitmap.new(hero_transform_pack:getTextureRegion("16.png")),
		Bitmap.new(hero_transform_pack:getTextureRegion("17.png")),
		Bitmap.new(hero_transform_pack:getTextureRegion("18.png")),
		Bitmap.new(hero_transform_pack:getTextureRegion("19.png")),

		
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
		{141, 160, animation[4], {scaleX = -options.hero_scale }},
		-- transform from human to monster 
		{161, 180, animation[5]},
		{181, 200, animation[6]},
		{201, 220, animation[7]},
		{221, 240, animation[8]},
		{241, 260, animation[9]},
		{261, 280, animation[10]},
		{281, 300, animation[11]},
		{301, 320, animation[12]},
		{321, 340, animation[13]},
		{341, 360, animation[14]},
		{361, 380, animation[15]},
		-- monster fight left
		{381, 400, animation[16], {scaleX = options.hero_scale }},
		{401, 420, animation[17], {scaleX = options.hero_scale }},
		-- monster fight right
		{421, 440, animation[16], {scaleX = -options.hero_scale }},
		{441, 460, animation[17], {scaleX = -options.hero_scale }},
		-- transform from monster to human
		{461, 480, animation[18]},
		{481, 500, animation[19]},
		{501, 520, animation[20]},
		{521, 540, animation[21]},
		{541, 560, animation[22]},
		{561, 580, animation[23]},
		
		-- @TODO: add monster wait animation!!!
			
	}
	
	self.hero_mc:setGotoAction(40, 	1)   -- human wait right
	self.hero_mc:setGotoAction(80, 	41)  -- human wait left
	self.hero_mc:setGotoAction(120, 1)  -- human fire right
	self.hero_mc:setGotoAction(160, 41) -- human fire left
	self.hero_mc:setGotoAction(420, 381) -- monster fire left
	self.hero_mc:setGotoAction(460, 421) -- monster fire right
	
	-- @TODO: set goto to wait monster
	self.hero_mc:setStopAction(380) -- transform to monster
	
	
	self.hero_mc:setGotoAction(580, 1) -- transform to human
	
	self.hero_mc:gotoAndPlay(1)
	
	self:addChild(self.hero_mc)
	
	self:setPosition(options.pos_x, options.pos_y)
	
end
