extends CharacterBody2D
@export var health : int
@export var damage : int
@export var speed : float
@onready var animation_player : AnimationPlayer = %AnimationPlayer
@onready var character_sprite : Sprite2D = %CharacterSprite
@onready var damage_emiter : Area2D = %DamageEmiter
enum State {IDLE, WALK, ATTACK}
var state = State.IDLE


func _ready() -> void:
	damage_emiter.area_entered.connect(on_emit_damage.bind())

func on_emit_damage(damager_receiver: DamageReceiver) -> void:
	var direction = Vector2.LEFT if damager_receiver.global_position.x < global_position.x else Vector2.RIGHT
	damager_receiver.damage_receive.emit(damage, direction)
	print(damager_receiver)
# 画面更新中
func _process(_delta: float) -> void:
	handle_input()
	handle_movement()
	handle_animation()
	flip_sprite()
	move_and_slide()
# 处理移动状态
func handle_movement() -> void:
	if can_move():
		if velocity.length() == 0:
			state = State.IDLE
		else:
			state = State.WALK
	else:
		velocity = Vector2.ZERO
# 处理键盘输入
func handle_input() -> void:
	var direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	velocity = direction * speed
	if can_attack() and Input.is_action_just_pressed("attack"):
		state = State.ATTACK
# 处理动画
func handle_animation() -> void:
	if state == State.IDLE:
		animation_player.play("idle")
	elif state == State.WALK:
		animation_player.play("walk")	
	elif state == State.ATTACK:
		animation_player.play("punch")	
# 处理朝向
func flip_sprite() -> void:
	if velocity.x > 0:
		character_sprite.flip_h = false
		damage_emiter.scale.x = 1
	elif velocity.x < 0:
		character_sprite.flip_h = true
		damage_emiter.scale.x = -1
# 检查是否处于可攻击状态
func can_attack() -> bool:
	return state == State.IDLE or state == State.WALK
# 检查是否处于可移动状态
func can_move() -> bool:
	return state == State.IDLE or state == State.WALK
# 
func on_action_complete() -> void:
	state = State.IDLE
