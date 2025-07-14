class_name UI
extends CanvasLayer
@onready var enemy_avatar: TextureRect = $UIContainer/EnemyAvator
@onready var player_healthbar: HeathBar = $UIContainer/PlayerHealthBar
@onready var enemy_healthbar: HeathBar = $UIContainer/EnemyHeathBar
@onready var combo_indicator: ComboIndicator = $UIContainer/ComboIndicator
@onready var score_indicator: ScoreIndicator = $UIContainer/ScoreIndicator
@onready var go_indicator: TextureRect = $UIContainer/GoIndicator
@export var duration_health_visible: int
var option_screen: OptionScreen = null
var time_start_healthbar_visible = Time.get_ticks_msec()
const avatar_map: Dictionary = {
	Character.Type.GOON: preload("res://assets/assets/art/ui/avatars/avatar-goon.png"),
	Character.Type.PUNK: preload("res://assets/assets/art/ui/avatars/avatar-punk.png"),
	Character.Type.THUG: preload("res://assets/assets/art/ui/avatars/avatar-thug.png"),
	Character.Type.BOSS: preload("res://assets/assets/art/ui/avatars/avatar-boss.png")
}
const OPTION_SCREEN_PREFAB = preload("res://UI/option/option_screen.tscn")


func _init() -> void:
	DamageManager.health_change.connect(on_character_health_change.bind())
	StageManager.checkpoint_complete.connect(on_checkpoint_complete.bind())

func _ready() -> void:
	enemy_avatar.visible = false
	enemy_healthbar.visible = false
	combo_indicator.combo_reset.connect(on_combo_reset.bind())

func on_combo_reset(points: int) -> void:
	score_indicator.add_combo(points)

func _process(delta: float) -> void:
	if enemy_healthbar.visible and(Time.get_ticks_msec() - time_start_healthbar_visible > duration_health_visible):
		enemy_avatar.visible = false
		enemy_healthbar.visible = false
	handle_input()

func handle_input() -> void:
	if Input.is_action_just_pressed("option"):
		if option_screen == null:
			option_screen = OPTION_SCREEN_PREFAB.instantiate()
			add_child(option_screen)
			option_screen.exit.connect(unpause.bind())
			get_tree().paused = true
		else:
			unpause()

func unpause() -> void:
	option_screen.queue_free()
	get_tree().paused = false

func on_character_health_change(type: Character.Type, current_health: int, max_health: int):
	if type == Character.Type.PLAYER:
		player_healthbar.refresh(current_health, max_health)
	else:
		time_start_healthbar_visible = Time.get_ticks_msec()
		enemy_avatar.texture = avatar_map[type]
		enemy_healthbar.refresh(current_health, max_health)
		enemy_avatar.visible = true
		enemy_healthbar.visible = true

func on_checkpoint_complete() -> void:
	go_indicator.start_flickering()
