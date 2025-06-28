class_name Character
extends CharacterBody2D
@export var health : int
@export var damage : int
@export var speed : float
@export var knockback_intensity: float
@export var jump_intensity : float
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var character_sprite : Sprite2D = $CharacterSprite
@onready var damage_emiter : Area2D = $DamageEmiter
@onready var damage_receciver: DamageReceiver = $DamageReceiver
enum State {IDLE, WALK, ATTACK, TAKE_OFF, JUMP, LAND, JUMPKICK, HURT}
const GRAVITY = 500
var state = State.IDLE
var height = 0.0
var height_speed = 0.0 
var current_health = 0
var animation_map = {
	State.IDLE: "idle",
	State.WALK: "walk",
	State.ATTACK: "punch",
	State.TAKE_OFF: "take_off",
	State.JUMP: "jump",
	State.LAND: "land",
	State.JUMPKICK: "jump_kick",
	State.HURT: "hurt"
}

# 节点生成后绑定当伤害发送器与伤害接受器碰撞时的回调函数，并将伤害接受器的对象作为参数传递给改回调函数
func _ready() -> void:
	damage_emiter.area_entered.connect(on_emit_damage.bind())
	damage_receciver.damage_receive.connect(on_rececive_damage.bind())
	current_health = health
# 游戏主循环中处理人物更新
func _process(delta: float) -> void:
	handle_input()
	handle_movement()
	handle_animation()
	handle_air_time(delta)
	flip_sprite()
	character_sprite.position = Vector2.UP * height
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
# 处理键盘输入
func handle_input() -> void:
	pass # override me
# 处理动画
func handle_animation() -> void:
	if animation_player.has_animation(animation_map[state]):
		animation_player.play(animation_map[state])
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
# 检查是否处于可跳跃状态
func can_jump() -> bool:
	return state == State.IDLE or state == State.WALK
# 检查是否处于可飞踢状态
func can_jump_kick() -> bool:
	return state == State.JUMP
# 当动画播放完后的回调函数
func on_action_complete() -> void:
	state = State.IDLE

func on_take_off_complete() -> void:
	state = State.JUMP
	height_speed = jump_intensity

func on_land_complete() -> void:
	state = State.IDLE

func handle_air_time(delta: float) -> void:
	if state == State.JUMP or state == State.JUMPKICK:
		height += height_speed * delta
		if height < 0:
			height = 0
			state = State.LAND
		else:
			height_speed -= GRAVITY * delta

func on_rececive_damage(damage: int, directinon: Vector2) -> void:
	current_health = clamp(current_health - damage, 0, health)
	if current_health <= 0:
		queue_free()
	else:
		state = State.HURT
		velocity = directinon * knockback_intensity
		
