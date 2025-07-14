class_name ActiveableContainer
extends HBoxContainer
@onready var label: Label = $Label
@export var text: String
@export var color_defaults: Color
@export var color_active: Color 
@export var current_value: int
@export var min_value: int
@export var max_value: int
var is_active: bool = false


func _ready() -> void:
	label.text = text
	set_value(current_value)

func _process(delta: float) -> void:
	handle_input()

func set_active(active: bool) -> void:
	is_active = active
	for control: Control in get_children():
		control.modulate = color_active if is_active else color_defaults 

func set_value(value: int) -> void:
	current_value = clampi(value, min_value, max_value)
	print(current_value)
	refresh()

func refresh() -> void:
	pass # override me

func handle_input() -> void:
	pass # override me
