application:setOrientation(application.LANDSCAPE_RIGHT)

sceneManager = SceneManager.new({
	["level"]  		= LevelScene,
	["tutorial"]  		= Tutorial,
    ["menu"]   		= MenuScene,    
	["game_over"] 	= GameOver
})

stage:addChild(sceneManager)

sceneManager:changeScene("menu", conf.TRANSITION_TIME,  SceneManager.fade,  easing.outBounce)
