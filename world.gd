extends Node2D
@onready var player = %player
@onready var camera = %Camera2D

# 在游戏主循环里让摄像机保持跟随玩家前进
func _process(_delta: float) -> void:
	if player.position.x > camera.position.x:
		camera.position.x = player.position.x
