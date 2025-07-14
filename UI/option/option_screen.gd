class_name OptionScreen
extends Control
@onready var music_control = $BackGroud/MarginContainer/VBoxContainer/MusicControl 
@onready var sfx_control = $BackGroud/MarginContainer/VBoxContainer/SFXControl
@onready var shake_control = $BackGroud/MarginContainer/VBoxContainer/ShakeToggePicker
@onready var return_control = $BackGroud/MarginContainer/VBoxContainer/Return
var activables: Array[ActiveableContainer] = [music_control, sfx_control, shake_control, return_control]
var current_selection_index: int = 0
signal exit


func _ready() -> void:
	activables = [music_control, sfx_control, shake_control, return_control]
	music_control.set_value(OptionManager.music_volume)
	sfx_control.set_value(OptionManager.sfx_volume)
	shake_control.set_value(OptionManager.is_screen_shake_enable as int)
	music_control.value_change.connect(on_music_value_change.bind())
	sfx_control.value_change.connect(on_sfx_value_change.bind())
	sfx_control.value_change.connect(on_is_shake_value_change.bind())
	return_control.press.connect(on_return_press.bind())
	refresh()

func refresh() -> void:
	for i in range(0, activables.size()):
		activables[i].set_active(current_selection_index == i)

func handle_input() -> void:
	if Input.is_action_just_pressed("ui_down"):
		current_selection_index = (current_selection_index + 1) % activables.size()
		SoundPlayer.play(SoundManager.Sound.CLICK)
		refresh()
	if Input.is_action_just_pressed("ui_up"):
		current_selection_index = (current_selection_index - 1 + activables.size()) % activables.size()
		SoundPlayer.play(SoundManager.Sound.CLICK)
		refresh()

func _process(delta: float) -> void:
	handle_input()

func on_music_value_change(value: int) -> void:
	OptionManager.set_music_value(value)

func on_sfx_value_change(value: int) -> void:
	OptionManager.set_sfx_value(value)

func on_is_shake_value_change(value: int) -> void:
	OptionManager.set_screen_shake(value == 1)

func on_return_press() -> void:
	exit.emit()
