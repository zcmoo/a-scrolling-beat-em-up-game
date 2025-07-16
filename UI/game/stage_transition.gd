class_name StageTransition
extends Control
@onready var animation_player = $AnimationPlayer


func start_transition() -> void:
	animation_player.play("start_transition")

func end_transition() -> void:
	animation_player.play("end_transition")

func on_complete_start_transition() -> void:
	animation_player.play("interion")
	StageManager.stage_interin.emit()

func on_complete_end_transition() -> void:
	animation_player.play("idle")
