class_name ScoreIndicator
extends Label
const DURATON_SCORE_UPDATE = 500.0
const POINTS_PER_LIFE = 1000
var current_score: int
var prior_score: int
var real_score: int
var time_start_update = Time.get_ticks_msec()


func _init() -> void:
	DamageManager.player_revive.connect(on_player_revive.bind())

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

func on_player_revive() -> void:
	real_score = max(0, real_score - POINTS_PER_LIFE)
	prior_score = current_score
	time_start_update = Time.get_ticks_msec()

func add_score(points: int) -> void:
	real_score = max(0, real_score + points)
	prior_score = current_score
	time_start_update = Time.get_ticks_msec()
