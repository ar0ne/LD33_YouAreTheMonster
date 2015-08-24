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
	startAttack
--]]

function Enemy:init(options)
	
	self.level = options.level
	self.paused = false
	self.direction = options.direction
	self.border = options.border
	self.color = options.color
	self.speed = options.speed
	self.is_attack = false
	self.startAttack = options.startAttack
	
	local enemy_blue_wait_spritesheet 	= Texture.new("assets/images/AI_blue_wait.png")
	local enemy_red_wait_spritesheet 	= Texture.new("assets/images/AI_red_wait.png")
	local enemy_blue_fly_spritesheet 	= Texture.new("assets/images/AI_blue_fly.png")
	local enemy_red_fly_spritesheet 	= Texture.new("assets/images/AI_red_fly.png")
	local enemy_blue_fall_spritesheet 	= Texture.new("assets/images/AI_blue_fall.png")
	local enemy_red_fall_spritesheet 	= Texture.new("assets/images/AI_red_fall.png")
	
	local enemy_blue_fight_foot_spritesheet = Texture.new("assets/images/AI_blue_fight_foot.png")
	local enemy_red_fight_foot_spritesheet = Texture.new("assets/images/AI_red_fight_foot.png")
	local enemy_blue_fight_hand_spritesheet = Texture.new("assets/images/AI_blue_fight_hand.png")
	local enemy_red_fight_hand_spritesheet = Texture.new("assets/images/AI_red_fight_hand.png")
	
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
		
		Bitmap.new(TextureRegion.new(enemy_blue_fight_foot_spritesheet,   0, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_blue_fight_foot_spritesheet,  50, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_blue_fight_foot_spritesheet, 100, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_blue_fight_foot_spritesheet, 150, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_blue_fight_foot_spritesheet, 200, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_blue_fight_foot_spritesheet, 250, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_blue_fight_foot_spritesheet, 300, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_blue_fight_foot_spritesheet, 350, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_blue_fight_foot_spritesheet, 400, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_blue_fight_foot_spritesheet, 450, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_blue_fight_foot_spritesheet, 500, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_blue_fight_foot_spritesheet, 550, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_blue_fight_foot_spritesheet, 600, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_blue_fight_foot_spritesheet, 6500, 0, 50, 50)),
		
		Bitmap.new(TextureRegion.new(enemy_red_fight_foot_spritesheet,   0, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_red_fight_foot_spritesheet,  50, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_red_fight_foot_spritesheet, 100, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_red_fight_foot_spritesheet, 150, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_red_fight_foot_spritesheet, 200, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_red_fight_foot_spritesheet, 250, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_red_fight_foot_spritesheet, 300, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_red_fight_foot_spritesheet, 350, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_red_fight_foot_spritesheet, 400, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_red_fight_foot_spritesheet, 450, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_red_fight_foot_spritesheet, 500, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_red_fight_foot_spritesheet, 550, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_red_fight_foot_spritesheet, 600, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_red_fight_foot_spritesheet, 6500, 0, 50, 50)),
		
		Bitmap.new(TextureRegion.new(enemy_blue_fight_hand_spritesheet,     0, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_blue_fight_hand_spritesheet,    50, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_blue_fight_hand_spritesheet,   100, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_blue_fight_hand_spritesheet,   150, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_blue_fight_hand_spritesheet,   200, 0, 50, 50)),
		
		Bitmap.new(TextureRegion.new(enemy_red_fight_hand_spritesheet,     0, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_red_fight_hand_spritesheet,    50, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_red_fight_hand_spritesheet,   100, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_red_fight_hand_spritesheet,   150, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(enemy_red_fight_hand_spritesheet,   200, 0, 50, 50)),
		
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
		{81,  90, animation[5]},
		{91, 100, animation[6]},
		{101, 110, animation[7]},
		{111, 120, animation[8]},
		{121, 130, animation[9], {y = {0, -1000, "linear"}}, {alpha = {0, 1, "easeOut"}}},
		-- red fly
		{131, 140, animation[10]},
		{141, 150, animation[11]},
		{151, 160, animation[12]},
		{161, 170, animation[13]},
		{171, 180, animation[14], {y = {0, -1000, "linear"}}, {alpha = {0, 1, "easeOut"}}},
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
		-- blue fight foot
		{521, 525, animation[39]},
		{526, 530, animation[40]},
		{531, 535, animation[41]},
		{536, 540, animation[42]},
		{541, 545, animation[43]},
		{546, 550, animation[44]},
		{551, 555, animation[45]},
		{556, 560, animation[46]},
		{561, 565, animation[47]},
		{566, 570, animation[48]},
		{571, 575, animation[49]},
		{576, 580, animation[50]},
		{581, 585, animation[51]},
		{586, 590, animation[52]},
		-- red fight foot
		{591, 595, animation[53]},
		{596, 600, animation[54]},
		{601, 605, animation[55]},
		{606, 610, animation[56]},
		{611, 615, animation[57]},
		{616, 620, animation[58]},
		{621, 625, animation[59]},
		{626, 630, animation[60]},
		{631, 635, animation[61]},
		{636, 640, animation[62]},
		{641, 645, animation[63]},
		{646, 650, animation[64]},
		{651, 655, animation[65]},
		{656, 660, animation[66]},
		-- blue fight hand
		{661, 665, animation[67]},
		{666, 670, animation[68]},
		{671, 675, animation[69]},
		{676, 680, animation[70]},
		{681, 685, animation[71]},
		-- red fight hand
		{686, 690, animation[72]},
		{691, 695, animation[73]},
		{696, 700, animation[74]},
		{701, 705, animation[75]},
		{706, 710, animation[76]},
	}
	
	self.goto = {
		blue_wait = 1,
		blue_fall = 281,
		blue_fly = 81,
		blue_fight_foot = 521,
		blue_fight_hand = 661,
		
		red_wait = 41,
		red_fall = 401,
		red_fly = 131,
		red_fight_foot = 591,
		red_fight_hand = 686,
	}
	
	
	self.enemy_mc:setGotoAction(40, self.goto.blue_wait)  	-- blue wait
	self.enemy_mc:setGotoAction(80, self.goto.red_wait) 	-- red wait
	
	
	self.enemy_mc:setStopAction(130) -- blue fly
	self.enemy_mc:setStopAction(180) -- red fly
	self.enemy_mc:setStopAction(400) -- blue fall
	self.enemy_mc:setStopAction(520) -- red fall
	
	
	self.enemy_mc:setGotoAction(590, self.goto.blue_fight_hand) 	-- blue fight foot to hand
	self.enemy_mc:setGotoAction(685, self.goto.blue_fight_foot) 	-- blue fight hand to foot
	self.enemy_mc:setGotoAction(660, self.goto.red_fight_hand) 		-- red fight foot to hand
	self.enemy_mc:setGotoAction(710, self.goto.red_fight_foot) 		-- red fight hand to foot
	
	
	if self.color == "blue" then
		self.enemy_mc:gotoAndPlay(self.goto.blue_wait)
	elseif self.color == "red" then
		self.enemy_mc:gotoAndPlay(self.goto.red_wait)
	end
	
	
	self:addChild(self.enemy_mc)
	
	self:setPosition(options.pos_x, options.pos_y, 0.1)
	
	---- EVENTS ---- 
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	
end

function Enemy:onEnterFrame(event)

	if not self.paused then
	
		local x, y = self:getPosition()
		
		if x ~= self.border then 
			if self.direction == "right" then
				x = x + self.speed
			else
				x = x - self.speed
			end
		else
			if not self.is_attack then
				
				local frame = 1
				if self.color == "blue" then
					frame = _chooseBetweenTwoValue(self.goto.blue_fight_foot, self.goto.blue_fight_hand)
				else 
					frame = _chooseBetweenTwoValue(self.goto.red_fight_foot, self.goto.red_fight_hand)
				end
				self.enemy_mc:gotoAndPlay(frame)
				
				self.is_attack = true
				self.startAttack(self.direction, self.level)
			end
		end
		
		self:setPosition(x, y)
	end
end
