class_name OptionScreen
extends Control
@onready var music_control: ActiveableContainer = $BackGroud/MarginContainer/VBoxContainer/MusicControl 
@onready var sfx_control: ActiveableContainer = $BackGroud/MarginContainer/VBoxContainer/SFXControl
@onready var shake_control: ActiveableContainer = $BackGroud/MarginContainer/VBoxContainer/ShakeToggePicker
@onready var return_control: ActiveableContainer = $BackGroud/MarginContainer/VBoxContainer/Return
var activables: Array[ActiveableContainer] = [music_control, sfx_control, shake_control, return_control]
var current_selection_index: int = 0


func _ready() -> void:
	activables = [music_control, sfx_control, shake_control, return_control]
	refresh()

func refresh() -> void:
	for i in range(0, activables.size()):
		activables[i].set_active(current_selection_index == i)

func handle_input() -> void:
	if Input.is_action_just_pressed("ui_down"):
		current_selection_index = (current_selection_index + 1) % activables.size()
		refresh()
	if Input.is_action_just_pressed("ui_up"):
		current_selection_index = (current_selection_index - 1 + activables.size()) % activables.size()
		refresh()

func _process(delta: float) -> void:
	handle_input()
