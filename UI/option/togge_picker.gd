class_name ToggerPicker
extends ActiveableContainer
@onready var value_lable = $valueLable


func refresh() -> void:
	value_lable.text = "ON" if current_value == 1 else "OFF"

func handle_input() -> void:
	if is_active and (Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right")):
		set_value((current_value + 1) % 2)
		SoundPlayer.play(SoundManager.Sound.CLICK)
