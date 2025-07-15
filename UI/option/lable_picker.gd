class_name LabelPicker
extends ActiveableContainer
signal press


func handle_input() -> void:
	if is_active and Input.is_action_just_pressed("确定"):
		press.emit()
		SoundPlayer.play(SoundManager.Sound.CLICK)
