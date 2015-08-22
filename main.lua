require "box2d"

sceneManager = SceneManager.new({
	["level"]  = LevelScene,
    ["menu"]   = MenuScene,    
})

stage:addChild(sceneManager)

sceneManager:changeScene("menu", conf.TRANSITION_TIME,  SceneManager.fade)
