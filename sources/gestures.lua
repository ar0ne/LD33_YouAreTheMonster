Gestures = Core.class(EventDispatcher)

local function hitPoint (x, y, space)
	local x1 = space.x
	local y1 = space.y
	local x2 = space.x1
	local y2 = space.y1
	
	if x >= x1 and  x <= x2 and y >= y1 and  y <= y2 then
		return true
	else
		return false
	end
end

function Gestures:init(scene, callback)
	self.touches = {}
	self.scene = scene
	self.callback = callback
	self.scene:addEventListener(Event.TOUCHES_BEGIN, self.onTouchesBegin, self)
	self.scene:addEventListener(Event.TOUCHES_MOVE, self.onTouchesMove, self)
	self.scene:addEventListener(Event.TOUCHES_END, self.onTouchesEnd, self)
end

function Gestures:onTouchesBegin(event)
	self.touches[event.touch.id] = {}
	self.touches[event.touch.id].bool = true
	self.touches[event.touch.id].startX = event.touch.x
	self.touches[event.touch.id].startY = event.touch.y
end

function Gestures:onTouchesMove(event)
	if self.touches[event.touch.id] ~= nil and self.touches[event.touch.id].bool == true then
		self.touches[event.touch.id].deltaX = self.touches[event.touch.id].startX - event.touch.x
		self.touches[event.touch.id].deltaY = self.touches[event.touch.id].startY - event.touch.y
	end
end
 
function Gestures:onTouchesEnd(event)
	if self.touches[event.touch.id] ~= nil and self.touches[event.touch.id].bool == true then
		self.touches[event.touch.id].endX = event.touch.x
		self.touches[event.touch.id].endY = event.touch.y
		
		self.callback(self.touches[event.touch.id], self.scene)
		
		--table.remove(self.touches, event.touch.id)
	end
end
