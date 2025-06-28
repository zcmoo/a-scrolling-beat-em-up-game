extends CharacterBody2D
@export var health : int
@export var damage : int
@export var speed : float
@onready var animation_player : AnimationPlayer = %AnimationPlayer
@onready var character_sprite : Sprite2D = %CharacterSprite
@onready var damage_emiter : Area2D = %DamageEmiter
enum State {IDLE, WALK, ATTACK}
var state = State.IDLE

# 节点生成后绑定当伤害发送器与伤害接受器碰撞时的回调函数，并将伤害接受器的对象作为参数传递给改回调函数
func _ready() -> void:
	damage_emiter.area_entered.connect(on_emit_damage.bind())
# 游戏主循环中处理人物更新
func _process(_delta: float) -> void:
	handle_input()
	handle_movement()
	handle_animation()
	flip_sprite()
	move_and_slide()
# 当伤害发送器与伤害接受器碰撞时的回调函数，该函数会根据油桶的位置和角色位置判断油桶飞出的方向，并把信号发送给传递过来的伤害接收器
func on_emit_damage(damager_receiver: DamageReceiver) -> void:
	var direction = Vector2.LEFT if damager_receiver.global_position.x < global_position.x else Vector2.RIGHT
	damager_receiver.damage_receive.emit(damage, direction)
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
# 当动画播放完后的回调函数
func on_action_complete() -> void:
	state = State.IDLE
