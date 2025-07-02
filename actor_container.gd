extends Node2D
var prefab_map = {
	COllectible.Type.KNIFE : preload("res://Scence/props/knife.tscn"),
}

func _ready() -> void:
	EntityManager.sqawn_collectible.connect(on_spawn_colletible.bind())

func on_spawn_colletible(type: COllectible.Type, initial_state: COllectible.State, collectible_globle_postion: Vector2, collectible_direction: Vector2,) -> void:
	var collectible: COllectible = prefab_map[type].instantiate()
	collectible.state = initial_state
	collectible.global_position = collectible_globle_postion
	collectible.direction = collectible_direction
	add_child(collectible)
