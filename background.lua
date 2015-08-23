Background = Core.class(Sprite)

--[[
	level - reference to parent object
	image - background image
	bg_scale - image scale
	
	screen_width
	screen_height
--]]

function Background:init(options)

	self.level = options.level
	self.image = Bitmap.new(Texture.new(options.image))
	local scaleX = options.screen_width / self.image:getWidth()
	local scaleY = options.screen_height / self.image:getHeight()
	self.image:setAnchorPoint(0.5, 0.5)
	self.image:setScale(scaleX*2, scaleX*2)
	self.image:setPosition(options.screen_width/2, options.screen_height/2)
	
	self:addChild(self.image)

end

