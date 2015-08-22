LevelScene = Core.class(Sprite)

function LevelScene:init()

	self.paused = true
	self.sound = SoundManager.new()
	--self.sounds:add("point", "assets/sounds/sfx_point.mp3")
	
	
	---- EVENTS ------
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	--self.world:addEventListener(Event.BEGIN_CONTACT, self.onBeginContact, self)
	
	local screenW = application:getDeviceHeight()
	local screenH = application:getDeviceWidth()
	local timelinewidth = screenW * 0.2
	local timeLeft = Timeline.new(stage, screenW/10, screenH*0.2, timelinewidth, 20);
	local timeRight = Timeline.new(stage, screenW-screenW/10-timelinewidth, screenH*0.2, timelinewidth, 20);
	
	timeLeft:start(1);
	timeLeft:onEnd(function ()
		timeLeft:restart(2)
	end)
	
	timeRight:start(1.000000000000001);
	timeRight:onEnd(function ()
		timeRight:restart(2)
	end)
end

function LevelScene:onEnterFrame(event)

	if not self.paused then
				 
	end
end


