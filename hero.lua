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
	
	local monster_wait_spritesheet_frame_2 = Texture.new("assets/images/12_1.png") 
	
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
		
		-- @TODO: add to hero_transform_pack
		Bitmap.new(TextureRegion.new(monster_wait_spritesheet_frame_2, 0, 0, 50, 50)),

		
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
		
		-- monster wait right
		{581,  600, animation[16], {scaleX = options.hero_scale }},
		{601,  620, animation[24], {scaleX = options.hero_scale }},
		-- monster wait left
		{621, 640, animation[16], {scaleX = -options.hero_scale }},
		{641, 660, animation[24], {scaleX = -options.hero_scale }},
		
	}
	
	self.goto = {
		hero_wait_right = 1,
		hero_wait_left = 41,
		hero_fire_right = 81,
		hero_fire_left = 121,
		hero_transform_to_monster = 161,
		
		monster_wait_right = 581,
		monster_wait_left  = 621,
		
		monster_fire_left = 381,
		monster_fire_right = 421,
		
		monster_transform_to_human = 461,
		
	}
	
	self.hero_mc:setGotoAction(40, 	self.goto.hero_wait_right)   	-- human wait right
	self.hero_mc:setGotoAction(80, 	self.goto.hero_wait_left)  		-- human wait left
	self.hero_mc:setGotoAction(120, self.goto.hero_wait_right)  	-- human fire right
	self.hero_mc:setGotoAction(160, self.goto.hero_wait_left) 		-- human fire left
	
	self.hero_mc:setGotoAction(420, self.goto.monster_wait_left) 	-- monster fire left
	self.hero_mc:setGotoAction(460, self.goto.monster_wait_right) 	-- monster fire right
	
	self.hero_mc:setGotoAction(620, self.goto.monster_wait_right)  	-- monster wait right
	self.hero_mc:setGotoAction(660, self.goto.monster_wait_left)  	-- monster wait left
	
	self.hero_mc:setStopAction(380) 								-- transform to monster
	self.hero_mc:setStopAction(580)									-- transform to human
	
	self.hero_mc:gotoAndPlay(1)
	
	self:addChild(self.hero_mc)
	
	self:setPosition(options.pos_x, options.pos_y)
	
end
