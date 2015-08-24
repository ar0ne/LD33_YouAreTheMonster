Score = Core.class(Sprite)

--[[
	level
	center_x
	pos_y
	scale
--]]
function Score:init( options )

	self.level = options.level
	self.scale = options.scale
	self.pos_y = options.pos_y
	self.center_x = options.center_x

	self.numbers = {
		Texture.new("assets/fonts/big/font_big_0.png"),
		Texture.new("assets/fonts/big/font_big_1.png"),
		Texture.new("assets/fonts/big/font_big_2.png"),
		Texture.new("assets/fonts/big/font_big_3.png"),
		Texture.new("assets/fonts/big/font_big_4.png"),
		Texture.new("assets/fonts/big/font_big_5.png"),
		Texture.new("assets/fonts/big/font_big_6.png"),
		Texture.new("assets/fonts/big/font_big_7.png"),
		Texture.new("assets/fonts/big/font_big_8.png"),
		Texture.new("assets/fonts/big/font_big_9.png"),
	}
	
	self.count = 0
	self.imgs = {}
		
end

function Score:getScoreImages(num)
	local answer = {}
	
	if num == 0 then
		return {Bitmap.new(self.numbers[1])}
	end
	
	while num > 0 do
		answer[#answer + 1] = num % 10
		num = math.floor(num / 10)
	end
	
	local ret = {}
	for i = #answer, 1, -1 do
		ret[#ret + 1] = Bitmap.new(self.numbers[answer[i] + 1])
	end	
		
	return ret	
end

function Score:getScore()
	return self.count
end

function Score:setNewScore(new_score)

	if new_score == self.count and new_score ~= 0 then
		return false
	end
	
	self.count = new_score
	
	return true
end

function Score:updateScore(new_score)

	if self:setNewScore(new_score) then
	
		for i = 1, #self.imgs do
			self:removeChild(self.imgs[i])
			
		end
		
		self.imgs = {}
		self.imgs = self:getScoreImages(new_score)
		
		local image_width = self.numbers[1]:getWidth()
		
		for i = 1, #self.imgs do
		
			local num = self.imgs[i]
			
			num:setScale(self.scale, self.scale)
			num:setAnchorPoint(0.5, 0.5)
			
			if #self.imgs == 1 then
				self.imgs[i]:setPosition(self.center_x, 100)
			elseif #self.imgs == 2 then
				self.imgs[i]:setPosition(self.center_x + math.pow((-1), i) * image_width, self.pos_y)
			elseif #self.imgs == 3 then
				self.imgs[i]:setPosition(self.center_x + (i - 2) * image_width, self.pos_y)
			end
			
			self:addChild(num)
		end
	end

end