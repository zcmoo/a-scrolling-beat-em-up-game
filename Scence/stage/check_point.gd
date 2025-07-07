class_name Checkpoint
extends Node2D
@export var nb_simultaneous_enemies: int
@onready var enemies: Node2D = $enemies
@onready var player_detetion_area: Area2D = $PlayerDecetionArea
var enemy_data: Array[Data] = []
var is_activate = false
var activated_enemies_count = 0 


func _ready() -> void:
	player_detetion_area.body_entered.connect(on_player_enter.bind())
	EntityManager.death_enemy.connect(on_enemy_death.bind())
	for enemy: Character in enemies.get_children():
		enemy_data.append(Data.new(enemy.type, enemy.global_position))
		enemies.queue_free()

func _process(delta: float) -> void:
	if is_activate and can_spawn_enemies():
		var enemy = enemy_data.pop_front()
		EntityManager.spawn_enemy.emit(enemy)
		activated_enemies_count += 1

func on_player_enter(player: Player) -> void:
	if not is_activate:
		StageManager.checkpoint_start.emit()
		activated_enemies_count = 0
		is_activate = true

func can_spawn_enemies() -> bool:
	return enemy_data.size() > 0 and activated_enemies_count < nb_simultaneous_enemies

func on_enemy_death(enemy: Character) -> void:
	activated_enemies_count -= 1
	if activated_enemies_count == 0 and enemy_data.size() == 0:
		StageManager.checkpoint_complete.emit()
		queue_free()
