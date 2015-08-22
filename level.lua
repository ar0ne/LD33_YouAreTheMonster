LevelScene = Core.class(Sprite)

function LevelScene:init()
	
	self.world = b2.World.new(0, conf.GRAVITY, true)
	self.bodies = {}
	self.paused = true
	self.sound = SoundManager.new()
	--self.sounds:add("point", "assets/sounds/sfx_point.mp3")
	
	
	----- DEBUG ---------
	-- [[
	local debugDraw = b2.DebugDraw.new()
	self.world:setDebugDraw(debugDraw)
	self:addChild(debugDraw)
	--]]
	---------------------
	
	
	---- EVENTS ------
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	--self.world:addEventListener(Event.BEGIN_CONTACT, self.onBeginContact, self)
end

function LevelScene:onEnterFrame(event)

	if not self.paused then
		self.world:step(1/60, 8, 3)
		local body
		for i = 1, #self.bodies do
			body = self.bodies[i]
			body.object:setPosition(body:getPosition())
			
			body.object:setRotation(math.deg(body:getAngle()))
		end
				 
	end
end


--[[
function LevelScene:onBeginContact(event)
	local fixtureA = event.fixtureA
	local fixtureB = event.fixtureB
	local bodyA = fixtureA:getBody()
	local bodyB = fixtureB:getBody()
	
	if bodyA.type and bodyB.type then
		if ((bodyA.type == "player" and bodyB.type == "wall") or
			(bodyB.type == "player" and bodyA.type == "wall")) then
			print("Game Over")
			sceneManager:changeScene("level", conf.TRANSITION_TIME,  SceneManager.fade)
		end
	end
end
--]]

