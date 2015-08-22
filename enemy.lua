Enemy = Core.class(Sprite)

--[[
	level
	pos_x
	pos_y
	enemy_scale
	direction - (left/right) 
--]]

function Enemy:init(options)
	
	self.level = options.level
	self.paused = false
	self.direction = options.direction
	
	local animation = {
		Bitmap.new(Texture.new("assets/images/AI_blue.png")),
	}
	
	for i = 1, #animation do
		animation[i]:setScale(options.enemy_scale)
		animation[i]:setAnchorPoint(0.5, 0.5)
	end
	
	self.enemy_mc = MovieClip.new{
		{1, 20, animation[1]},
	}
	
	self:addChild(self.enemy_mc)
	
	self:setPosition(options.pos_x, options.pos_y)
	
	---- EVENTS ---- 
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	
end

function Enemy:onEnterFrame(event)
	if not self.paused then
		local x, y = self:getPosition()
		if self.direction == "right" then
			x = x + 1
		else
			x = x - 1
		end
		
		self:setPosition(x, y)
	end
end