class_name COllectible
extends Area2D
enum State {FALL, GROUND, FLY}
enum Type {KNIFE, GUN, FOOD}
var auto_destroy : bool
@export var type : Type
@export var speed : float
@export var damage : int
@export var knockdown_intensity : float
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var collectible_sprite : Sprite2D = $CollectSprite
@onready var damage_emitter : Area2D = $DamageEmiter
var anim_map ={
	State.FALL : "fall",
	State.GROUND : "ground",
	State.FLY : "fly"
}
var direction = Vector2.ZERO
var velocity = Vector2.ZERO
var height = 0.0
var height_speed = 0.0
const GRAVITY = 600.0
var state = State.FALL


func _ready() -> void:
	height_speed = knockdown_intensity 
	if state == State.FLY:
		velocity = direction * speed
	damage_emitter.area_entered.connect(on_emit_damage.bind())
	damage_emitter.body_exited.connect(on_exit_screen.bind())
	damage_emitter.position = Vector2.UP * height

func _process(delta: float) -> void:
	collectible_sprite.position = Vector2.UP * height
	position += velocity * delta
	collectible_sprite.flip_h = velocity.x < 0
	monitorable = state == State.GROUND
	damage_emitter.monitoring = state == State.FLY
	handle_fall(delta)
	handle_animation()

func handle_fall(delta: float) -> void:
	if state == State.FALL:
		height += height_speed * delta
		if auto_destroy:
			modulate.a -= delta
		if height < 0:
			height = 0
			state = State.GROUND
			if auto_destroy:
				queue_free()
		else:
			height_speed -= GRAVITY * delta

func handle_animation() -> void:
	if animation_player.has_animation(anim_map[state]):
		animation_player.play(anim_map[state])

func on_emit_damage(reciver: DamageReceiver) -> void:
	reciver.damage_receive.emit(damage, direction, DamageReceiver.HIType.KNOCKDOWN)
	queue_free()

func on_exit_screen(_wall: AnimatableBody2D) -> void:
	queue_free()
	
