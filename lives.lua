Lives = Core.class(Sprite)

function Lives:init(scene, opt)
	self.scene = scene
	self.groups = {}
	self.goodImage = opt.goodImage
	self.badImage = opt.badImage
	self.height = opt.size
end

function Lives:add(id, opt)
	local group = Sprite.new()
	local heart = Texture.new(self.goodImage)
	local liveOne = Bitmap.new(heart)
	local liveTwo = Bitmap.new(heart)
	local lastX = 0
	local scaleFactor = self.height / liveOne:getHeight()
	group.X = opt.X
	group.Y = opt.Y
	group.onHeartEnd = opt.onHeartEnd or nil
	group.onScullEnd = opt.onSkullEnd or nil
	liveOne:setScale(scaleFactor, scaleFactor)
	liveTwo:setScale(scaleFactor, scaleFactor)
	liveTwo:setX(liveOne:getWidth()+10)
	group:addChild(liveOne)
	group:addChild(liveTwo)
	group.anchorX = group:getWidth()/2
	group.anchorY = group:getHeight()/2
	group:setAnchorPosition(group.anchorX, group.anchorY)
	group:setPosition(group.X, group.Y)
	group.heart = 2
	group.skull = 2
	group.type = "heart"
	self.groups[id] = group
	self.scene:addChild(self.groups[id])
end

function Lives:render (one, two, id)
	local scene = self.scene
	local parentGroup = self.groups[id]
	local group = Sprite.new()
	group.X = parentGroup.X
	group.Y = parentGroup.Y
	group.onHeartEnd = parentGroup.onHeartEnd
	group.onScullEnd = parentGroup.onSkullEnd
	group.heart = parentGroup.heart
	group.skull = parentGroup.skull
	group.type = parentGroup.type
	group.anchorX = parentGroup.anchorX
	group.anchorY = parentGroup.anchorY
	group:setAnchorPosition(parentGroup.anchorX, parentGroup.anchorY)
	
	
		
		if one ~= nil then
			local scaleFactor = self.height / one:getHeight()
			one:setScale(scaleFactor, scaleFactor)
			group:addChild(one)
		end
		if two ~= nil then
			local scaleFactor = self.height / two:getHeight()
			two:setScale(scaleFactor, scaleFactor)
			two:setX(one:getWidth()+10)
			group:addChild(two)
		end
		group:setPosition(group.X, group.Y)
		self.groups[id]:removeFromParent()
		self.groups[id] = group
		scene:addChild(self.groups[id])
	
	
end

function Lives:decrement(id)
	local heartCount = self.groups[id].heart
	local skullCount = self.groups[id].skull
	local heart = Texture.new(self.goodImage)
	local skull = Texture.new(self.badImage)
	if self.groups[id].type == "heart" then
		if heartCount == 2 then
			print("2")
			local liveOne = Bitmap.new(heart)
			local liveTwo = nil
			self.groups[id].heart = 1
			self:render(liveOne, liveTwo, id)
		elseif heartCount == 1 then
			print("1")
			local liveOne = nil
			local liveTwo = nil
			self.groups[id].heart = 0
			self:render(liveOne, liveTwo, id)
			if self.groups[id].onHeartEnd ~= nil then
				print("onend")
				self.groups[id].onHeartEnd(self)
			end
		end
	elseif self.groups[id].type == "skull" then
		if skullCount == 2 then
			local liveOne = Bitmap.new(skull)
			local liveTwo = nil
			self.groups[id].skull = 1
			self:render(liveOne, liveTwo, id)
		elseif skullCount == 1 then
			local liveOne = nil
			local liveTwo = nil
			self.groups[id].skull = 0
			self:render(liveOne, liveTwo, id)
			if self.groups[id].onSkullEnd ~= nil then
				self.groups[id].onSkullEnd(self)
			end
		end
	end
end

function Lives:getLiveCount(id)
	if self.type == "heart" then
		return self.groups[id].heart
	elseif self.type == "skull" then
		return self.groups[id].skull
	end
end

function Lives:setType(id, type)
	self.groups[id].type = type
	local heartCount = self.groups[id].heart
	local skullCount = self.groups[id].skull
	local heart = Texture.new(self.goodImage)
	local skull = Texture.new(self.badImage)
	if self.groups[id].type == "heart" then
		local liveOne = Bitmap.new(heart)
		local liveTwo = Bitmap.new(heart)
		self.groups[id].heart = 2
		self:render(liveOne, liveTwo, id)
	elseif self.groups[id].type == "skull" then
		local liveOne = Bitmap.new(skull)
		local liveTwo = Bitmap.new(skull)
		self.groups[id].skull = 2
		self:render(liveOne, liveTwo, id)
	end
end

