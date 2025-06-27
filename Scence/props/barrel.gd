extends StaticBody2D
@export var knockback_intensity : float
@onready var damage_receiver = %DamageReceiver
@onready var sprite = %Sprite2D
var velocity = Vector2.ZERO
enum State {IDLE, DESTORYED}
var state = State.IDLE
var height = 0.0
var height_speed = 0.0
const GRAVITY = 500

func _ready() -> void:
	damage_receiver.damage_receive.connect(on_receive_damage.bind())

func on_receive_damage(damage: int, direction: Vector2) -> void:
	if state == State.IDLE:
		sprite.frame = 1
		height_speed = knockback_intensity * 2
		state = State.DESTORYED
		velocity = direction * knockback_intensity
		print(velocity)

func _process(delta: float) -> void:
	position += velocity * delta
	sprite.position = Vector2.UP * height
	handle_air_time(delta)

func handle_air_time(delta: float) -> void:
	if state == State.DESTORYED:
		modulate.a -= delta
		height += height_speed * delta
		if height < 0:
			height = 0
			queue_free()
		else:
			height_speed -= GRAVITY * delta
			
