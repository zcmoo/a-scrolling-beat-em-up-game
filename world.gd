extends Node2D
@onready var player = %player
@onready var camera = %Camera2D
var is_camera_locked = false


func _ready() -> void:
	StageManager.checkpoint_start.connect(on_checkpoint_start.bind())
	StageManager.checkpoint_complete.connect(on_checkpoint_complete.bind())

# 在游戏主循环里让摄像机和空气墙保持跟随玩家前进（注意在用animatable_body对象时要关闭Sync to Physical功能才能让空气墙随玩家移动）
func _process(_delta: float) -> void:
	if not is_camera_locked and player.position.x > camera.position.x:
		camera.position.x = player.position.x

func on_checkpoint_start() -> void:
	is_camera_locked = true

func on_checkpoint_complete() -> void:
	is_camera_locked = false
