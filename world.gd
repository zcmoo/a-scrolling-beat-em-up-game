extends Node2D
@onready var player = %player
@onready var camera = %Camera2D


func _process(_delta: float) -> void:
	if player.position.x > camera.position.x:
		camera.position.x = player.position.x
