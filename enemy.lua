Enemy = Core.class(Sprite)

--[[
	level
	pos_x
	pos_y
	enemy_scale
	direction - (left/right) 
	color - (blue/red)
	middle 
	speed
--]]

function Enemy:init(options)
	
	self.level = options.level
	self.paused = false
	self.direction = options.direction
	self.middle = options.middle
	self.color = options.color
	self.speed = options.speed
	
	local enemy_blue_wait_spritesheet 	= Texture.new("assets/images/AI_blue_wait.png")
	local enemy_red_wait_spritesheet 	= Texture.new("assets/images/AI_red_wait.png")
	local enemy_blue_fly_spritesheet 	= Texture.new("assets/images/AI_blue_fly.png")
	local enemy_red_fly_spritesheet 	= Texture.new("assets/images/AI_red_fly.png")
	local enemy_blue_fall_spritesheet 	= Texture.new("assets/images/AI_blue_fall.png")
	local enemy_red_fall_spritesheet 	= Texture.new("assets/images/AI_red_fall.png")
	
	local animation = {
	
		Bitmap.new(TextureRegion.new(enemy_blue_wait_spritesheet,  0, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_blue_wait_spritesheet, 50, 0, 50, 50)),
		
		Bitmap.new(TextureRegion.new(enemy_red_wait_spritesheet,   0, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_red_wait_spritesheet,  50, 0, 50, 50)),
		
		Bitmap.new(TextureRegion.new(enemy_blue_fly_spritesheet,   0, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_blue_fly_spritesheet,  50, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_blue_fly_spritesheet, 100, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_blue_fly_spritesheet, 150, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_blue_fly_spritesheet, 200, 0, 50, 50)),
		
		Bitmap.new(TextureRegion.new(enemy_red_fly_spritesheet,   0, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_red_fly_spritesheet,  50, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_red_fly_spritesheet, 100, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_red_fly_spritesheet, 150, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_red_fly_spritesheet, 200, 0, 50, 50)),
		
		Bitmap.new(TextureRegion.new(enemy_blue_fall_spritesheet,   0, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_blue_fall_spritesheet,  50, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_blue_fall_spritesheet, 100, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_blue_fall_spritesheet, 150, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_blue_fall_spritesheet, 200, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_blue_fall_spritesheet, 250, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_blue_fall_spritesheet, 300, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_blue_fall_spritesheet, 350, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_blue_fall_spritesheet, 400, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_blue_fall_spritesheet, 450, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_blue_fall_spritesheet, 500, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_blue_fall_spritesheet, 550, 0, 50, 50)),
		
		Bitmap.new(TextureRegion.new(enemy_red_fall_spritesheet,   0, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_red_fall_spritesheet,  50, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_red_fall_spritesheet, 100, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_red_fall_spritesheet, 150, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_red_fall_spritesheet, 200, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_red_fall_spritesheet, 250, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_red_fall_spritesheet, 300, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_red_fall_spritesheet, 350, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_red_fall_spritesheet, 400, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_red_fall_spritesheet, 450, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_red_fall_spritesheet, 500, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_red_fall_spritesheet, 550, 0, 50, 50)),
		
	}
	
	for i = 1, #animation do
		-- if enemy move to the left then flip sprite
		if self.direction == "right" then
			animation[i]:setScale(  options.enemy_scale, options.enemy_scale)
		else
			animation[i]:setScale( -options.enemy_scale, options.enemy_scale)
		end
		animation[i]:setAnchorPoint(0.5, 0.5)
	end
	
	self.enemy_mc = MovieClip.new{
		-- blue wait
		{1,  20, animation[1]},
		{21, 40, animation[2]},
		-- red wait
		{41, 60, animation[3]},
		{61, 80, animation[4]},
		-- blue fly
		{81,  100, animation[5]},
		{101, 120, animation[6]},
		{121, 140, animation[7]},
		{141, 160, animation[8]},
		{161, 180, animation[9], {y = {0, -1000, "linear"}}, {alpha = {0, 1, "easeOut"}}},
		-- red fly
		{181, 200, animation[10]},
		{201, 220, animation[11]},
		{221, 240, animation[12]},
		{241, 260, animation[13]},
		{261, 280, animation[14], {y = {0, -1000, "linear"}}, {alpha = {0, 1, "easeOut"}}},
		-- blue fall 
		{281, 290, animation[15]},
		{291, 300, animation[16]},
		{301, 310, animation[17]},
		{311, 320, animation[18]},
		{321, 330, animation[19]},
		{331, 340, animation[20]},
		{341, 350, animation[21]},
		{351, 360, animation[22]},
		{361, 370, animation[23]},
		{371, 380, animation[24]},
		{381, 390, animation[25]},
		{391, 400, animation[26], {alpha = {0, 1, "easeOut"}}},
		-- red fall
		{401, 410, animation[27]},
		{411, 420, animation[28]},
		{421, 430, animation[29]},
		{431, 440, animation[30]},
		{441, 450, animation[31]},
		{451, 460, animation[32]},
		{461, 470, animation[33]},
		{471, 480, animation[34]},
		{481, 490, animation[35]},
		{491, 500, animation[36]},
		{501, 510, animation[37]},
		{511, 520, animation[38], {alpha = {0, 1, "easeOut"}}},
		
	}
	
	self.enemy_mc:setGotoAction(40, 1)  -- blue wait
	self.enemy_mc:setGotoAction(80, 41) -- red wait
	
	self.enemy_mc:setStopAction(180)
	self.enemy_mc:setStopAction(280)
	self.enemy_mc:setStopAction(400)
	self.enemy_mc:setStopAction(520)
	
	if self.color == "blue" then
		self.enemy_mc:gotoAndPlay(1)
	elseif self.color == "red" then
		self.enemy_mc:gotoAndPlay(41)
	end
	
	self:addChild(self.enemy_mc)
	
	self:setPosition(options.pos_x, options.pos_y)
	
	---- EVENTS ---- 
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	
end

function Enemy:onEnterFrame(event)

	if not self.paused then
	
		local x, y = self:getPosition()
		if self.direction == "right" then
			x = x + self.speed
		else
			x = x - self.speed
		end
		
		if x == self.middle then
			-- 	сверяем цвет и режим героя
			-- if self.color ~= self.level.hero.mode then
			--	
			
			self:removeEnemyFromLevel(self.level.enemys_left)
			self:removeEnemyFromLevel(self.level.enemys_right)
			
		end
		
		self:setPosition(x, y)
	end
end

function Enemy:removeEnemyFromLevel(enemy_array)
	for i = 1, #enemy_array do
		if enemy_array[i] == self then
			table.remove(enemy_array, i)
			self.level:removeChild(self) -- getParent() doesn't work
			break
		end
	end
end