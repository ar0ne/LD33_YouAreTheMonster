Stars = Core.class(Sprite)

--[[
	level
	scale_x
	scale_y
	alpha
--]]
function Stars:init(opt)

	self.level = opt.level
	self.paused = false
	
	local stars_spritesheet = {
		Bitmap.new(Texture.new("assets/images/Stars_01.png")),
		Bitmap.new(Texture.new("assets/images/Stars_02.png")),
		Bitmap.new(Texture.new("assets/images/Stars_03.png")),
	}
	
	for i = 1, #stars_spritesheet do 
		stars_spritesheet[i]:setAnchorPoint(0, 0)
		stars_spritesheet[i]:setScale(opt.scale_x, opt.scale_y)
		stars_spritesheet[i]:setAlpha(opt.alpha)
	end
	
	self.stars_mc = MovieClip.new {
		{  1, 100, stars_spritesheet[1]},
		{101, 200, stars_spritesheet[2]},
		{201, 300, stars_spritesheet[3]},
	}
	
	self.stars_mc:setGotoAction(300, 1)
	
	self.stars_mc:gotoAndPlay(1)
	
	self:addChild(self.stars_mc)
	
	
end
