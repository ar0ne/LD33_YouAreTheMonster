Clouds = Core.class(Sprite)

--[[
	level
	scale_x
	scale_y
	screen_width
	speed

--]]
function Clouds:init( options )
	
	self.level = options.level
	self.screen_width = options.screen_width
	self.speed = options.speed
	self.paused = false
	
	self.clouds = {
		Bitmap.new(Texture.new("assets/images/Clouds.png")),
		Bitmap.new(Texture.new("assets/images/Clouds.png")),
		Bitmap.new(Texture.new("assets/images/Clouds.png")),
	}
	
	for i = 1, #self.clouds do 
		self.clouds[i]:setAnchorPosition(0, 0)
		self.clouds[i]:setScale(options.scale_x, options.scale_y)
		self.clouds[i]:setPosition((i - 2) * self.screen_width, 0)
		self:addChild(self.clouds[i])
	end
	
	
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	
end

function Clouds:onEnterFrame()

	if not self.paused then
		for i = 1, #self.clouds do
			self.clouds[i]:setPosition(self.clouds[i]:getX() - self.speed , 0)
				
			-- if some image hide from screen then replace it
			if self.clouds[i]:getX() + self.screen_width <= 0  then
				self.clouds[i]:setX(self.screen_width )
			end
		end
	end
	
end