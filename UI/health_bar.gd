class_name HeathBar
extends Control
@onready var content_background: ColorRect = $ContentBackground
@onready var health_bar: TextureRect = $health_bar
@onready var white_border: ColorRect = $WhiteBorder
@export var is_inverted: bool


func refresh(current_health: int , max_health: int) -> void:
	var rev = -1 if is_inverted else 1
	white_border.scale.x = (int(max_health / 10) + 2) * rev
	content_background.scale.x = (int(max_health / 10)) * rev
	health_bar.scale.x = (int(current_health / 10)) * rev
