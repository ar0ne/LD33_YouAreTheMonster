Timeline = Core.class(Sprite)

local gt = os.timer
local shape = Shape
function Timeline:init(scene)
	self.scene = scene
	self.timelines = {}
	self.scene:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end

function Timeline:onEnd(func)
	self.onend = func
end

function Timeline:addLine (id, X, Y, W, H, callback)
	local line = {}
	line.id = id
	line.x = X
	line.y = Y
	line.w = W
	line.h = H
	
	line.callback = callback
	line.started = false
	line.ended = false
	
	self.timelines[id] = line
end

function Timeline:start(id, Time)
	local timeline = self.timelines[id]
	timeline.shape = shape.new()
	timeline.shape:setFillStyle(Shape.SOLID, 0xFDE3A7, 1)
	timeline.shape:beginPath()
	timeline.shape:moveTo(0,0)
	timeline.shape:lineTo(timeline.w, 0)
	timeline.shape:lineTo(timeline.w, timeline.h)
	timeline.shape:lineTo(0, timeline.h)
	timeline.shape:lineTo(0, 0)
	timeline.shape:endPath()
	timeline.shape:setPosition(timeline.x, timeline.y)
	self.scene:addChild(timeline.shape)
	
	timeline.fullshape = shape.new()
	timeline.fullshape:setFillStyle(Shape.SOLID, 0xF89406, 1)
	timeline.fullshape:beginPath()
	timeline.fullshape:moveTo(0,0)
	timeline.fullshape:lineTo(timeline.w, 0)
	timeline.fullshape:lineTo(timeline.w, timeline.h)
	timeline.fullshape:lineTo(0, timeline.h)
	timeline.fullshape:lineTo(0, 0)
	timeline.fullshape:endPath()
	timeline.fullshape:setPosition(timeline.x, timeline.y)
	self.scene:addChild(timeline.fullshape)
	
	timeline.ended = false
	timeline.started = true
	timeline.time = Time
	timeline.endtime = gt() + Time
end

function Timeline:restart(id, Time)
	local timeline = self.timelines[id]
	timeline.started = true
	timeline.ended = false
	timeline.time = Time
	timeline.endtime = gt() + Time
end

function Timeline:stop(id, Time)
	self.timelines[id].started = false
end

function Timeline:onEnterFrame()
	local timeline = self.timelines
	local perc = 0
	for i = 1, #timeline do
		if timeline[i].started == true then
			perc = (timeline[i].endtime - gt()) / timeline[i].time
			if perc > 0 then
				timeline[i].fullshape:clear()
				timeline[i].fullshape = shape.new()
				timeline[i].fullshape:setFillStyle(Shape.SOLID, 0xF89406, 1)
				timeline[i].fullshape:beginPath()
				timeline[i].fullshape:moveTo(0,0)
				timeline[i].fullshape:lineTo(timeline[i].w * perc, 0)
				timeline[i].fullshape:lineTo(timeline[i].w * perc, timeline[i].h)
				timeline[i].fullshape:lineTo(0, timeline[i].h)
				timeline[i].fullshape:lineTo(0, 0)
				timeline[i].fullshape:endPath()
				timeline[i].fullshape:setPosition(timeline[i].x, timeline[i].y)
				self.scene:addChild(timeline[i].fullshape)
			else
				timeline[i].fullshape:clear()
				timeline[i].fullshape = shape.new()
				timeline[i].fullshape:setPosition(timeline[i].x, timeline[i].y)
				self.scene:addChild(timeline[i].fullshape)
				if timeline[i].callback ~= nil and timeline[i].ended == false then
					timeline[i].ended = true
					timeline[i].callback(self)
				end
			end
		end
	end
	
end