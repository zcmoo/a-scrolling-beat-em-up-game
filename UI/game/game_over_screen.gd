class_name GameOverScreen
extends Control
@onready var score_indicator = $BackGround/MarginContainer/VBoxContainer/HBoxContainer/ScoreIndicator
@onready var timer = $Timer
@onready var lable: Label = $BackGround/MarginContainer/VBoxContainer/Label
var total_score = 0


func _ready() -> void:
	timer.timeout.connect(on_timer_timeout.bind())

func set_score(score: int) -> void:
	total_score = score

func set_text(is_pass: bool) -> void:
	lable.text = "VICTORY" if is_pass else "DEFEAT"
	lable.add_theme_color_override("font_color", Color.GREEN) if is_pass else lable.add_theme_color_override("font_color", Color.RED)

func on_timer_timeout() -> void:
	score_indicator.add_score(total_score)
