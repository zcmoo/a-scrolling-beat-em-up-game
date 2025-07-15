extends Node2D
@export var player: Player
@export var left_wall: AnimatableBody2D 
@export var right_wall: AnimatableBody2D
var doors: Array[Door] = []
const SHOT_PREFAB = preload("res://Scence/props/shot.tscn")
const SPARK_PREFAB = preload("res://Scence/props/spark.tscn")
const PREB_MAP = {
	COllectible.Type.KNIFE : preload("res://Scence/props/knife.tscn"),
	COllectible.Type.GUN : preload("res://Scence/props/gun.tscn"),
	COllectible.Type.FOOD : preload("res://Scence/props/food.tscn"),
}
const ENEMY_MAP = {
	Character.Type.PUNK : preload("res://Scence/character/basic_enemy.tscn"),
	Character.Type.GOON : preload("res://Scence/character/gooenemy.tscn"),
	Character.Type.THUG : preload("res://Scence/character/thug_enemy.tscn"),
	Character.Type.BOSS : preload("res://Scence/character/lgor_boss.tscn"),
}


func _init() -> void:
	EntityManager.ofphan_actor.connect(on_ofphan_actor.bind())
	EntityManager.sqawn_collectible.connect(on_spawn_colletible.bind())
	EntityManager.sqawn_shot.connect(on_spawn_shot.bind())
	EntityManager.spawn_enemy.connect(on_spawn_enemy.bind())
	EntityManager.spawn_park.connect(on_spawn_spark.bind())
	DamageManager.player_revive.connect(on_player_revive.bind())

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

func on_spawn_enemy(enemy_data: Data) -> void:
	var enemy: Character = ENEMY_MAP[enemy_data.type].instantiate()
	enemy.global_position = enemy_data.global_position
	enemy.height = enemy_data.height
	enemy.state = enemy_data.state
	enemy.player = player
	if enemy_data.type == Character.Type.BOSS:
		enemy.left_wall = left_wall
		enemy.right_wall = right_wall
	if enemy_data.door_index > -1:
		enemy.assign_door(doors[enemy_data.door_index])	
	add_child(enemy)

func on_ofphan_actor(ofphan: Node2D) -> void:
	if ofphan is Door:
		doors.append(ofphan)
	ofphan.reparent(self)
	
func on_spawn_spark(spark_postion: Vector2) -> void:
	var spark_instance = SPARK_PREFAB.instantiate()
	spark_instance.position = spark_postion
	add_child(spark_instance)

func on_player_revive() -> void:
	for child in get_children():
		if child is Character:
			var charater: Character = child as Character
			if charater.type != Character.Type.PLAYER:
				charater.on_rececive_damage(0, Vector2.ZERO, DamageReceiver.HIType.KNOCKDOWN)
