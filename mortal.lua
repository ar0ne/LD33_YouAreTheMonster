Mortal = Core.class(Sprite)

function Mortal:init(opt)

	self.level = opt.level
	self.added = false
	local lue_spritesheet = Texture.new("assets/images/LueKang.png")
	
	self.speed = opt.speed
	
	local lue_animation = {
	
		Bitmap.new(TextureRegion.new(lue_spritesheet,   0, 0, 75, 55)),
		Bitmap.new(TextureRegion.new(lue_spritesheet,  75, 0, 75, 55)),
		Bitmap.new(TextureRegion.new(lue_spritesheet, 150, 0, 75, 55)),
		Bitmap.new(TextureRegion.new(lue_spritesheet,   0, 0, 75, 55)),
		Bitmap.new(TextureRegion.new(lue_spritesheet,  75, 0, 75, 55)),
		Bitmap.new(TextureRegion.new(lue_spritesheet, 150, 0, 75, 55)),
	}
	
	for i = 1, #lue_animation do
		lue_animation[i]:setScale(opt.scale, opt.scale)
		lue_animation[i]:setAnchorPoint(0.5, 0.5)
	end
	
	self.lue_mc = MovieClip.new{
		{1,   5, lue_animation[1]},
		{6,  10, lue_animation[2]},
		{11, 15, lue_animation[3]},
		{16, 20, lue_animation[4]},
		{21, 25, lue_animation[5]},
		{26, 30, lue_animation[6]},
	}
	
	self.lue_mc:setGotoAction(30, 1)
	
	self.lue_mc:gotoAndPlay(1)
	
	self:setPosition(opt.pos_x, opt.pos_y)
	
	self:addChild(self.lue_mc)

	self:addEventListener(Event.ENTER_FRAME, self.onEnter, self)
	self:addEventListener(Event.ADDED_TO_STAGE, function()
		self.added = true
	end, self)
end

function Mortal:onEnter()
	local x = self:getX()
	self:setX(x + self.speed)
end

