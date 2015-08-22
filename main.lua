require "box2d"

application:setOrientation(application.LANDSCAPE_RIGHT)

sceneManager = SceneManager.new({
	["level"]  = LevelScene,
    ["menu"]   = MenuScene,    
})

stage:addChild(sceneManager)

sceneManager:changeScene("menu", conf.TRANSITION_TIME,  SceneManager.fade)
