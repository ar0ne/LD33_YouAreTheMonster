Timeline = Core.class(Sprite)

function Timeline:init(scene, X, Y, W, H)
	self.scene = scene
	self.x = X
	self.y = Y
	self.w = W
	self.h = H
	self.percent = 100
	self.onend = nil
	self.ended = false
end

function Timeline:onEnd(func)
	self.onend = func
end

function Timeline:start(Time)
	self.shape = Shape.new()
	self.shape:setFillStyle(Shape.SOLID, 0xFDE3A7, 1)
	self.shape:beginPath()
	self.shape:moveTo(0,0)
	self.shape:lineTo(self.w, 0)
	self.shape:lineTo(self.w, self.h)
	self.shape:lineTo(0, self.h)
	self.shape:lineTo(0, 0)
	self.shape:endPath()
	self.shape:setPosition(self.x, self.y)
	stage:addChild(self.shape)
	
	self.fullshape = Shape.new()
	self.fullshape:setFillStyle(Shape.SOLID, 0xF89406, 1)
	self.fullshape:beginPath()
	self.fullshape:moveTo(0,0)
	self.fullshape:lineTo(self.w, 0)
	self.fullshape:lineTo(self.w, self.h)
	self.fullshape:lineTo(0, self.h)
	self.fullshape:lineTo(0, 0)
	self.fullshape:endPath()
	self.fullshape:setPosition(self.x, self.y)
	stage:addChild(self.fullshape)
	
	self.time = Time
	self.endtime = os.timer() + Time
	
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end

function Timeline:restart(Time)
	self.ended = false
	self.time = Time
	self.endtime = os.timer() + Time
end

function Timeline:onEnterFrame()
	local perc = (self.endtime - os.timer()) * 100 / self.time / 100
	
	if perc > 0 then
		self.fullshape:clear()
		self.fullshape = Shape.new()
		self.fullshape:setFillStyle(Shape.SOLID, 0xF89406, 1)
		self.fullshape:beginPath()
		self.fullshape:moveTo(0,0)
		self.fullshape:lineTo(self.w * perc, 0)
		self.fullshape:lineTo(self.w * perc, self.h)
		self.fullshape:lineTo(0, self.h)
		self.fullshape:lineTo(0, 0)
		self.fullshape:endPath()
		self.fullshape:setPosition(self.x, self.y)
		stage:addChild(self.fullshape)
	else
		self.fullshape:clear()
		self.fullshape = Shape.new()
		self.fullshape:setPosition(self.x, self.y)
		stage:addChild(self.fullshape)
		if self.onend ~= nil and self.ended == false then
			self.ended = true
			self.onend()
		end
	end
end