class_name RangePicker
extends ActiveableContainer
@onready var ticks_container = $TicksContainer
const TICK_ON = preload("res://assets/assets/art/ui/ui-tick-on.png")
const TICK_OFF = preload("res://assets/assets/art/ui/ui-tick-off.png")


func refresh() -> void:
	var ticks = ticks_container.get_children()
	for i in range(0, current_value):
		ticks[i].texture = TICK_ON
	for i in range(current_value, ticks.size()):
		ticks[i].texture = TICK_OFF

func handle_input() -> void:
	if is_active and Input.is_action_just_pressed("ui_left"):
		set_value(current_value - 1)
		SoundPlayer.play(SoundManager.Sound.CLICK)
	if is_active and Input.is_action_just_pressed("ui_right"):
		set_value(current_value + 1)
		SoundPlayer.play(SoundManager.Sound.CLICK)
