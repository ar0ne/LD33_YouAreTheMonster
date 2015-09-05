Tutorial = Core.class(Sprite)

function Tutorial:init()
	
	
	--load frames
local frames = {}
local bmp
for i = 1, 2 do
	bmp = Bitmap.new(Texture.new("assets/images/Tutorial_0"..i..".png", true))
	local scaleFactor = conf.SCREENW / bmp:getWidth()
	bmp:setScale(scaleFactor, scaleFactor)
	bmp:setAnchorPoint(0.5, 0.5)
	bmp:setPosition(conf.SCREENW / 2, conf.SCREENH / 2)
	frames[#frames+1] = bmp
end

--arrange frames
local ballAnimation = MovieClip.new{
	{1, 10, frames[1]}, 
	{11, 20, frames[2]}
}

--loop animation
ballAnimation:setGotoAction(20, 1)

--start playing
ballAnimation:gotoAndPlay(1)

self:addChild(ballAnimation)
self:addEventListener(Event.TOUCHES_END, Tutorial.onUp)
end

function Tutorial:onUp()
	sceneManager:changeScene("level", conf.TRANSITION_TIME,  SceneManager.fade)
end