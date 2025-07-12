class_name ScoreIndicator
extends Label
const DURATON_SCORE_UPDATE = 300.0
var current_score: int
var prior_score: int
var real_score: int
var time_start_update = Time.get_ticks_msec()


func _ready() -> void:
	text = str(0)

func _process(delta: float) -> void:
	if current_score != real_score:
		var progress = (Time.get_ticks_msec() - time_start_update) / DURATON_SCORE_UPDATE
		if progress < 1:
			current_score = lerp(prior_score, real_score, progress)
		else:
			current_score = real_score
	text = str(current_score)

func add_combo(points: int) -> void:
	real_score += int((points * (points + 1)) / 2.0)
	prior_score = current_score
	time_start_update = Time.get_ticks_msec()
