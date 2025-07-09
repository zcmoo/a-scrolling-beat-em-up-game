class_name Stage
extends Node2D
@onready var containers: Node2D = $Containers
@onready var doors: Node2D = $Doors
@onready var check_points: Node2D = $Checkpoints

func _ready() -> void:
	for container: Node2D in containers.get_children():
		EntityManager.ofphan_actor.emit(container)
	for i in range(doors.get_child_count()):
		var door: Door = doors.get_child(i)
		for enemy in door.enemies:
			enemy.assigned_door_index = i
	for door: Node2D in doors.get_children():
		EntityManager.ofphan_actor.emit(door)
	for check_point: Checkpoint in check_points.get_children():
		check_point.creat_enemy_data()
