extends Node
signal sqawn_collectible(type: COllectible.Type, initial_state: COllectible.State, collectible_globle_postion: Vector2, collectible_direction: Vector2, initial_height: float, auto_distroy: bool)
signal sqawn_shot(gun_root_postion: Vector2, distance_traveled: float, height: float)
signal spawn_enemy(enemy_data: Data)
signal death_enemy(enemy: Character)
signal ofphan_actor(orphan: Node2D)
signal spawn_park(spark_position: Vector2)
