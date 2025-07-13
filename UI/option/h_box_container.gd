class_name ActiveableContainer
extends HBoxContainer
@onready var label: Label = $Label
@export var text: String
@export var color_defaults: Color
@export var color_active: Color 
var is_active: bool = false


func _ready() -> void:
	label.text = text

func set_active(active: bool) -> void:
	is_active = active
	for control: Control in get_children():
		control.modulate = color_active if is_active else color_defaults 
