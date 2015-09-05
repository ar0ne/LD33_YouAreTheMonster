Crowd = Core.class(Sprite)

--[[
	level 
	scale
	pos_x
	pos_y
	
--]]
function Crowd:init(opt)
	self.level = opt.level
	
	local crowd_spritesheet = Texture.new("assets/images/crowd.png")
	
	local crowd_anim = {
		Bitmap.new(TextureRegion.new(crowd_spritesheet,   0, 0, 150, 50)),
		Bitmap.new(TextureRegion.new(crowd_spritesheet, 150, 0, 150, 50)),
		Bitmap.new(TextureRegion.new(crowd_spritesheet, 300, 0, 150, 50)),
		Bitmap.new(TextureRegion.new(crowd_spritesheet, 450, 0, 150, 50)),
		Bitmap.new(TextureRegion.new(crowd_spritesheet, 600, 0, 150, 50)),
		Bitmap.new(TextureRegion.new(crowd_spritesheet, 750, 0, 150, 50)),
		Bitmap.new(TextureRegion.new(crowd_spritesheet, 900, 0, 150, 50)),
		Bitmap.new(TextureRegion.new(crowd_spritesheet, 1050, 0, 150, 50)),
	}
	
	for i = 1, #crowd_anim do
		crowd_anim[i]:setAnchorPoint(0.5, 0.5)
		crowd_anim[i]:setScale(opt.scale, opt.scale)
	end
	
	local shadow_spritesheet = Bitmap.new(Texture.new("assets/images/shadow.png"))
	shadow_spritesheet:setAnchorPoint(0.5, 0.4)
	shadow_spritesheet:setScale(opt.scale * 5, opt.scale)
	self:addChild(shadow_spritesheet)
	
	self.crowd_mc = MovieClip.new {
		{ 1, 10, crowd_anim[1]},
		{11, 20, crowd_anim[2]},
		{21, 30, crowd_anim[3]},
		{31, 40, crowd_anim[4]},
		{41, 50, crowd_anim[5]},
		{51, 60, crowd_anim[6]},
		{61, 70, crowd_anim[7]},
		{71, 80, crowd_anim[8]},
	}
	
	self.crowd_mc:setGotoAction(80, 1)
	self:addChild(self.crowd_mc)
	
	self:setPosition(opt.pos_x, opt.pos_y)
	
end