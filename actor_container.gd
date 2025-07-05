extends Node2D
const SHOT_PREFAB = preload("res://Scence/props/shot.tscn")
const PREB_MAP = {
	COllectible.Type.KNIFE : preload("res://Scence/props/knife.tscn"),
	COllectible.Type.GUN : preload("res://Scence/props/gun.tscn"),
	COllectible.Type.FOOD : preload("res://Scence/props/food.tscn")
}


func _ready() -> void:
	EntityManager.sqawn_collectible.connect(on_spawn_colletible.bind())
	EntityManager.sqawn_shot.connect(on_spawn_shot.bind())

func on_spawn_colletible(type: COllectible.Type, initial_state: COllectible.State, collectible_globle_postion: Vector2, collectible_direction: Vector2, initial_height: float, auto_distroy: bool) -> void:
	var collectible: COllectible = PREB_MAP[type].instantiate()
	collectible.height = initial_height
	collectible.state = initial_state
	collectible.global_position = collectible_globle_postion
	collectible.direction = collectible_direction
	collectible.auto_destroy = auto_distroy
	call_deferred("add_child", collectible)

func on_spawn_shot(gun_root_postion: Vector2, distance_traveled: float, height: float) -> void:
	var shot: Shot	= SHOT_PREFAB.instantiate()
	add_child(shot)
	shot.position = gun_root_postion
	shot.initialize(distance_traveled, height)
	

	
