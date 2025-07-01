extends Node2D
@onready var player = %player
@onready var camera = %Camera2D

# 在游戏主循环里让摄像机和空气墙保持跟随玩家前进（注意在用animatable_body对象时要关闭Sync to Physical功能才能让空气墙随玩家移动）
func _process(_delta: float) -> void:
	if player.position.x > camera.position.x:
		camera.position.x = player.position.x

		
