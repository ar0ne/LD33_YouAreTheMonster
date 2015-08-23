Timeline = Core.class(Sprite)

function Timeline:init(scene)
	self.scene = scene
	self.timelines = {}
	self.scene:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	--[[self.x = X
	self.y = Y
	self.w = W
	self.h = H
	self.percent = 100
	self.onend = nil
	self.ended = false--]]
end

function Timeline:onEnd(func)
	self.onend = func
end

function Timeline:addLine (id, X, Y, W, H, callback)
	self.timelines[id] = {}
	self.timelines[id].id = id
	self.timelines[id].x = X
	self.timelines[id].y = Y
	self.timelines[id].w = W
	self.timelines[id].h = H
	
	self.timelines[id].callback = callback
	self.timelines[id].started = false
	self.timelines[id].ended = false
end

function Timeline:start(id, Time)
	self.timelines[id].shape = Shape.new()
	self.timelines[id].shape:setFillStyle(Shape.SOLID, 0xFDE3A7, 1)
	self.timelines[id].shape:beginPath()
	self.timelines[id].shape:moveTo(0,0)
	self.timelines[id].shape:lineTo(self.timelines[id].w, 0)
	self.timelines[id].shape:lineTo(self.timelines[id].w, self.timelines[id].h)
	self.timelines[id].shape:lineTo(0, self.timelines[id].h)
	self.timelines[id].shape:lineTo(0, 0)
	self.timelines[id].shape:endPath()
	self.timelines[id].shape:setPosition(self.timelines[id].x, self.timelines[id].y)
	self.scene:addChild(self.timelines[id].shape)
	
	self.timelines[id].fullshape = Shape.new()
	self.timelines[id].fullshape:setFillStyle(Shape.SOLID, 0xF89406, 1)
	self.timelines[id].fullshape:beginPath()
	self.timelines[id].fullshape:moveTo(0,0)
	self.timelines[id].fullshape:lineTo(self.timelines[id].w, 0)
	self.timelines[id].fullshape:lineTo(self.timelines[id].w, self.timelines[id].h)
	self.timelines[id].fullshape:lineTo(0, self.timelines[id].h)
	self.timelines[id].fullshape:lineTo(0, 0)
	self.timelines[id].fullshape:endPath()
	self.timelines[id].fullshape:setPosition(self.timelines[id].x, self.timelines[id].y)
	self.scene:addChild(self.timelines[id].fullshape)
	
	self.timelines[id].started = true
	self.timelines[id].time = Time
	self.timelines[id].endtime = os.timer() + Time
end

function Timeline:restart(id, Time)
	self.timelines[id].started = true
	self.timelines[id].ended = false
	self.timelines[id].time = Time
	self.timelines[id].endtime = os.timer() + Time
end

function Timeline:stop(id, Time)
	self.timelines[id].started = false
end

function Timeline:onEnterFrame()
	for i = 1, #self.timelines do
		if self.timelines[i].started == true then
			local perc = (self.timelines[i].endtime - os.timer()) * 100 / self.timelines[i].time / 100
			if perc > 0 then
				self.timelines[i].fullshape:clear()
				self.timelines[i].fullshape = Shape.new()
				self.timelines[i].fullshape:setFillStyle(Shape.SOLID, 0xF89406, 1)
				self.timelines[i].fullshape:beginPath()
				self.timelines[i].fullshape:moveTo(0,0)
				self.timelines[i].fullshape:lineTo(self.timelines[i].w * perc, 0)
				self.timelines[i].fullshape:lineTo(self.timelines[i].w * perc, self.timelines[i].h)
				self.timelines[i].fullshape:lineTo(0, self.timelines[i].h)
				self.timelines[i].fullshape:lineTo(0, 0)
				self.timelines[i].fullshape:endPath()
				self.timelines[i].fullshape:setPosition(self.timelines[i].x, self.timelines[i].y)
				self.scene:addChild(self.timelines[i].fullshape)
			else
				self.timelines[i].fullshape:clear()
				self.timelines[i].fullshape = Shape.new()
				self.timelines[i].fullshape:setPosition(self.timelines[i].x, self.timelines[i].y)
				self.scene:addChild(self.timelines[i].fullshape)
				if self.timelines[i].callback ~= nil and self.timelines[i].ended == false then
					self.timelines[i].ended = true
					self.timelines[i].callback()
				end
			end
		end
	end
	
end