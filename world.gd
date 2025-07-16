extends Node2D
@onready var camera = %Camera2D
@onready var stage_container = %StageContainer
@onready var actor_container = %ActorContainer
@onready var stage_transition = $UI/UIContainer/Stage_transition
var is_camera_locked = false
var is_game_over = false
var current_stage_index = -1
var camer_initial_position = Vector2.ZERO
var is_stage_ready_for_load = false
var player: Player = null
const STAGE_PREFAB = [
	preload("res://Scence/stage/stage_01_street.tscn"),
	preload("res://Scence/stage/stage-02-bar.tscn")
]
const PlAYER_PREFAB = preload("res://Scence/character/player.tscn")


func _ready() -> void:
	camer_initial_position = camera.position
	StageManager.checkpoint_start.connect(on_checkpoint_start.bind())
	StageManager.checkpoint_complete.connect(on_checkpoint_complete.bind())
	StageManager.stage_interin.connect(load_next_stage.bind())
	load_next_stage()

func _process(_delta: float) -> void:
	if is_stage_ready_for_load:
		is_stage_ready_for_load = false
		var stage: Stage = STAGE_PREFAB[current_stage_index].instantiate()
		stage_container.add_child(stage)
		player = PlAYER_PREFAB.instantiate()
		actor_container.add_child(player)
		player.position = stage.get_player_spawn_location()
		actor_container.player = player
		camera.position = camer_initial_position
		camera.reset_smoothing()
		stage_transition.end_transition()

	if is_game_over:
		is_game_over = false
		StageManager.game_over.emit(true)

	if not is_camera_locked and player.position.x > camera.position.x and player != null:
		camera.position.x = player.position.x

func on_checkpoint_start() -> void:
	is_camera_locked = true

func on_checkpoint_complete(_checkpoint: Checkpoint) -> void:
	is_camera_locked = false

func load_next_stage() -> void:
	current_stage_index += 1

	if current_stage_index < STAGE_PREFAB.size():
		for actor: Node2D in actor_container.get_children():
			actor.queue_free()
		for existing_stage in stage_container.get_children():
			existing_stage.queue_free()
		is_stage_ready_for_load = true

	if current_stage_index == STAGE_PREFAB.size():
		is_game_over = true
	
