Background = Core.class(Sprite)

--[[
	level - reference to parent object
	image - background image
	bg_scale - image scale
	pos_x - position at the X axes of screen
	pox_y - position at the Y axes of screen
--]]

function Background:init(options)

	self.level = options.level
	self.image = Bitmap.new(Texture.new(options.image))
	self.image:setAnchorPoint(0.5, 0.5)
	self.image:setScale(options.bg_scale, options.bg_scale)
	self.image:setPosition(options.pos_x, options.pos_y)
	
	self:addChild(self.image)
	
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)

end

function Background:onEnterFrame(e)
	
end