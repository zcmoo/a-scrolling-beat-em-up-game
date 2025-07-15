class_name DeathScreen
extends MarginContainer
@onready var count_lable = $ColorRect/MarginContainer/ColorRect/VBoxContainer/Count
@onready var timer = $Timer
@export var count_down_start: int
var current_count = 0
signal game_over


func _ready() -> void:
	current_count = count_down_start
	refresh()
	timer.timeout.connect(on_time_timeout.bind())

func _process(delta: float) -> void:
	if current_count < count_down_start and (Input.is_action_just_pressed("attack") or Input.is_action_just_pressed("jump") or Input.is_action_just_pressed("确定")):
		DamageManager.player_revive.emit()
		queue_free()

func on_time_timeout() -> void:
	if current_count > 0:
		current_count -= 1
		refresh()
	else:
		game_over.emit()
		queue_free()

func refresh() -> void:
	count_lable.text = str(current_count)
