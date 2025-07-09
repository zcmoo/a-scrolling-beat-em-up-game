class_name Data
extends Resource
const DROP_HEIGHT = 50
var door_index: int
var global_position: Vector2
var type: Character.Type
var state : Character.State
var height : int


func _init(character_type: Character.Type = Character.Type.PUNK, postion: Vector2 = Vector2.ZERO, assigned_door_index: int = -1) -> void:
	door_index = assigned_door_index
	type = character_type
	if postion.y < 0:
		height = DROP_HEIGHT
		global_position = postion + Vector2.DOWN * height
		state = Character.State.DROP
	else:
		global_position = postion
		state = Character.State.IDLE
		
	
	
