class_name Door
extends Node2D
@export var duration_open : float
@export var enemies : Array[BaiscEnemy]
@onready var door_sprite: Sprite2D = $DoorSprite2D
enum State {CLOSE, OPENING, OPENED}
signal opened
var door_height = 0
var state = State.CLOSE
var time_start_opening = Time.get_ticks_msec()


func _ready() -> void:
	door_height = door_sprite.texture.get_height()

func open() -> void:
	if state == State.CLOSE:
		state = State.OPENING
		time_start_opening = Time.get_ticks_msec()

func _process(delta: float) -> void:
	if state == State.OPENING:
		if Time.get_ticks_msec() - time_start_opening > duration_open:
			state = State.OPENED
			door_sprite.position = Vector2.UP * door_height
			opened.emit()
		else:
			var progress = (Time.get_ticks_msec() - time_start_opening) / duration_open 
			door_sprite.position = lerp(Vector2.ZERO, Vector2.UP * door_height, progress)
