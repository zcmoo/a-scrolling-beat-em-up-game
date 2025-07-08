class_name Character
extends CharacterBody2D
@export var type : Type
@export var can_respawn : bool
@export var damage : int
@export var health : int
@export var damage_power : int
@export var damage_gun_shot : float
@export var max_ammo_per_gun : int
@export_group("Movement")
@export var duration_ground : float
@export var flight_speed : float
@export var jump_intensity : float
@export var speed : float
@export var knockdown_intensity : float
@export var knockback_intensity : float
@export_group("Weapons")
@export var autodestroy_on_drop : bool
@export var can_resqawn_knives : bool
@export var duration_between_knife_resqawn : int
@export var has_knife : bool
@export var has_gun : bool
# 需要被其它子场景继承并调用自己的子节点时必须用$引用其它节点，不能用%
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var character_sprite : Sprite2D = $CharacterSprite
@onready var damage_emiter : Area2D = $DamageEmiter
@onready var damage_receciver : DamageReceiver = $DamageReceiver
@onready var collision_shape : CollisionShape2D = $CollisionShape2D
@onready var collater_damage_emiter : Area2D = $collateralDamageEmiter
@onready var knife_sprite : Sprite2D = $KnifeSprite
@onready var raycast : RayCast2D = $RayCast2D
@onready var collectible_sensor : Area2D = $CollectibleSensor
@onready var weapon_postion : Node2D = $KnifeSprite/WeaponPostion 
@onready var gun_sprite : Sprite2D = $GunSprite
enum State {IDLE, WALK, ATTACK, TAKE_OFF, JUMP, LAND, JUMPKICK, HURT, FALL, GROUND, DEATH, FLY, PREP_ATTACK, THROW, PICK_UP, SHOOT, PRE_SHOOT, RECOVER, DROP}
enum Type {PLAYER, PUNK, GOON, THUG, BOSS}
const GRAVITY = 500
var state = State.IDLE
var height = 0.0
var height_speed = 0.0 
var current_health = 0
var is_last_hit_successful = false
var heading = Vector2.RIGHT
var attack_combo_index = 0
var time_since_ground = Time.get_ticks_msec() 
var time_since_knife_dismiss = Time.get_ticks_msec()
var anim_attack = []
var ammo_left = 0
# 定义播放动画的字典
var animation_map : Dictionary = {
	State.IDLE: "idle",
	State.WALK: "walk",
	State.ATTACK: "punch",
	State.TAKE_OFF: "take_off",
	State.JUMP: "jump",
	State.LAND: "land",
	State.JUMPKICK: "jump_kick",
	State.HURT: "hurt",
	State.FALL: "fall",
	State.GROUND: "ground",
	State.DEATH: "ground",
	State.FLY: "fly",
	State.PREP_ATTACK : "idle",
	State.THROW : "throw",
	State.PICK_UP : "pick_up",
	State.SHOOT : "shoot",
	State.PRE_SHOOT : "idle",
	State.RECOVER : "recover",
	State.DROP : "idle"
}


# 节点生成后绑定当伤害发送器与伤害接受器碰撞时的回调函数，并将伤害接受器的对象作为参数传递给改回调函数
func _ready() -> void:
	set_sprite_height_postion()
	damage_emiter.area_entered.connect(on_emit_damage.bind())
	damage_receciver.damage_receive.connect(on_rececive_damage.bind())
	collater_damage_emiter.area_entered.connect(on_emit_collateral_damage.bind())
	collater_damage_emiter.body_entered.connect(on_wall_hit.bind())
	current_health = health
# 游戏主循环中处理人物更新逻辑
func _process(delta: float) -> void:
	setup_collisions()
	set_sprite_height_postion()
	set_sprite_visibility()
	handle_input()
	handle_movement()
	handle_pre_shoot()
	handle_knife_resqwan()
	handle_animation()
	handle_air_time(delta)
	handle_prep_attack()
	hand_ground()
	handle_death(delta)
	set_heading()
	flip_sprite()
	move_and_slide()

func setup_collisions() -> void:
	damage_receciver.monitorable = can_get_hurt()
	collision_shape.disabled = is_collision_disabled()
	if self.type != Character.Type.BOSS:
		damage_emiter.monitoring = is_attacking()
	else:
		damage_emiter.monitoring = state == State.FLY
	if self.type != Character.Type.BOSS:
		collater_damage_emiter.monitoring = state == State.FLY
	else:
		collater_damage_emiter.monitoring = is_attacking()

func set_sprite_height_postion() -> void:
	gun_sprite.position = Vector2.UP * height 
	character_sprite.position = Vector2.UP * height
	knife_sprite.position = Vector2.UP * height

func set_sprite_visibility() -> void:
	knife_sprite.visible = has_knife
	gun_sprite.visible = has_gun
# 当伤害发送器与伤害接受器碰撞时的回调函数，该函数会根据油桶的位置和角色位置判断油桶飞出的方向，并把信号发送给传递过来的伤害接收器
func on_emit_damage(damager_receiver: DamageReceiver) -> void:
	var hi_type = DamageReceiver.HIType.NOMAL
	var direction = Vector2.LEFT if damager_receiver.global_position.x < global_position.x else Vector2.RIGHT
	var curent_damage = damage
	if state == State.JUMPKICK:
		hi_type = DamageReceiver.HIType.KNOCKDOWN
	if attack_combo_index == anim_attack.size() - 1:
		hi_type = DamageReceiver.HIType.POWER
		curent_damage = damage_power
	damager_receiver.damage_receive.emit(curent_damage, direction, hi_type)
	is_last_hit_successful = true
# 处理移动状态
func handle_movement() -> void:
	if can_move():
		if velocity.length() == 0:
			state = State.IDLE
		else:
			state = State.WALK
func handle_pre_shoot() -> void:
	pass # override me
# 处理键盘输入，在子节点被重写
func handle_input() -> void:
	pass # override me
# 处理动画
func handle_animation() -> void:
	if state == State.ATTACK:
		animation_player.play(anim_attack[attack_combo_index])
	elif animation_player.has_animation(animation_map[state]):
		animation_player.play(animation_map[state])
# 处理朝向
func flip_sprite() -> void:
	if not can_move():
		return
	if heading == Vector2.RIGHT:
		character_sprite.flip_h = false
		knife_sprite.scale.x = 1
		gun_sprite.scale.x = 1
		raycast.scale.x = 1
		damage_emiter.scale.x = 1
	else:
		character_sprite.flip_h = true
		knife_sprite.scale.x = -1
		gun_sprite.scale.x = -1
		raycast.scale.x = -1
		damage_emiter.scale.x = -1
# 检查是否处于可攻击状态
func can_attack() -> bool:
	return state == State.IDLE or state == State.WALK
# 检查是否是攻击（敌人）的状态
func  is_attacking() -> bool:
	return [State.ATTACK, State.JUMPKICK].has(state)
# 检查是否处于可移动状态
func can_move() -> bool:
	return state == State.IDLE or state == State.WALK
# 检查是否处于可跳跃状态
func can_jump() -> bool:
	return state == State.IDLE or state == State.WALK
# 检查是否携带武器
func is_carring_weapon() -> bool:
	return has_knife or has_gun
# 检查是否处于可飞踢状态
func can_jump_kick() -> bool:
	return state == State.JUMP
# 检查是否处于可攻击状态
func can_get_hurt() -> bool:
	return [State.IDLE, State.WALK, State.TAKE_OFF, State.LAND, State.ATTACK, State.PREP_ATTACK, State.SHOOT, State.PRE_SHOOT].has(state)
# 当动画播放完后的回调函数
func on_action_complete() -> void:
	state = State.IDLE
# 当准备跳的动画播放完后的回调函数
func on_take_off_complete() -> void:
	state = State.JUMP
	height_speed = jump_intensity
# 当着陆的动画播放完后的回调函数
func on_land_complete() -> void:
	state = State.IDLE
# 处理角色跳起来时受到重力影响
func handle_air_time(delta: float) -> void:
	if [State.JUMP, State.JUMPKICK, State.FALL, State.DROP].has(state):
		height += height_speed * delta
		if height < 0:
			height = 0
			if state == State.FALL:
				state = State.GROUND
				time_since_ground = Time.get_ticks_msec()
			else:
				state = State.LAND
			velocity = Vector2.ZERO
		else:
			height_speed -= GRAVITY * delta
# 角色收到攻击后扣血和击退和击飞
func on_rececive_damage(damage: int, directinon: Vector2, hi_type: DamageReceiver.HIType) -> void:
	if can_get_hurt():
		attack_combo_index = 0
		heading = -directinon
		can_resqawn_knives = false
		if has_knife:
			has_knife = false
			EntityManager.sqawn_collectible.emit(COllectible.Type.KNIFE, COllectible.State.FALL, global_position, Vector2.ZERO, 0.0, autodestroy_on_drop)
			time_since_knife_dismiss = Time.get_ticks_msec()
		if has_gun:
			has_gun = false
			EntityManager.sqawn_collectible.emit(COllectible.Type.GUN, COllectible.State.FALL, global_position, Vector2.ZERO, 0.0, autodestroy_on_drop)
		current_health = clamp(current_health - damage, 0, health)
		if current_health == 0 or hi_type == DamageReceiver.HIType.KNOCKDOWN:
			state = State.FALL
			height_speed = knockdown_intensity
			velocity = directinon * knockback_intensity
		elif hi_type == DamageReceiver.HIType.POWER:
			state = State.FLY
			velocity = directinon * flight_speed
		else:
			state = State.HURT
			velocity = directinon * knockback_intensity
# 处理角色被击飞通过计时器过渡到着陆状态
func hand_ground() -> void:
	if state == State.GROUND and (Time.get_ticks_msec() - time_since_ground > duration_ground):
		if current_health <= 0:
			state = State.DEATH
		else:
			state = State.LAND
# 处理死亡状态
func handle_death(delta: float) -> void:
	if state == State.DEATH and not can_respawn:
		modulate.a -= delta / 2.0
		if modulate.a <= 0:
			queue_free()
 # 判断是否关闭碰撞功能
func is_collision_disabled() -> bool:
	return [State.GROUND, State.DEATH, State.FLY].has(state)
# 处理敌人撞墙发弹功能
func on_wall_hit(wall: AnimatableBody2D) -> void:
	state = State.FALL
	height_speed = knockdown_intensity
	velocity = -velocity / 2.0
# 处理敌人被连招击飞后与其它敌人相撞后的动作
func on_emit_collateral_damage(reciever: DamageReceiver) -> void:
	if reciever != damage_receciver:
		var direction = Vector2.LEFT if damage_receciver.global_position.x < global_position.x else Vector2.RIGHT
		reciever.damage_receive.emit(10, direction, DamageReceiver.HIType.KNOCKDOWN)
# 处理人物朝向问题
func set_heading() -> void:
	pass # override me

func handle_prep_attack() -> void:
	pass

func on_throw_complete() -> void:
	state = State.IDLE
	var collect_type = COllectible.Type.KNIFE
	if has_gun:
		collect_type = COllectible.Type.GUN
		has_gun = false
	else:
		has_knife = false
	var collectible_global_postion = Vector2(weapon_postion.global_position.x, global_position.y)
	var collectible_height = -weapon_postion.position.y
	EntityManager.sqawn_collectible.emit(collect_type, COllectible.State.FLY, collectible_global_postion, heading, collectible_height, false)

func handle_knife_resqwan() -> void:
	if can_resqawn_knives and not has_knife and (Time.get_ticks_msec() - time_since_knife_dismiss > duration_between_knife_resqawn):
		has_knife = true	

func on_pick_up_complete() -> void:
	state = State.IDLE
	pickup_collectible()

func can_pick_up() -> bool:
	if can_resqawn_knives:
		return false
	if Time.get_ticks_msec() - time_since_knife_dismiss < duration_between_knife_resqawn:
		return false
	var collectible_area = collectible_sensor.get_overlapping_areas()
	if collectible_area.size() == 0:
		return false
	var collectible : COllectible = collectible_area[0]
	if collectible.type == COllectible.Type.KNIFE and not is_carring_weapon():
		return true
	if collectible.type == COllectible.Type.GUN and not is_carring_weapon():
		return true
	if collectible.type == COllectible.Type.FOOD:
		return true	
	return false

func pickup_collectible() -> void:
	if can_pick_up():
		var collectible_area = collectible_sensor.get_overlapping_areas() 
		var collectible : COllectible = collectible_area[0]
		if collectible.type == COllectible.Type.KNIFE and not has_knife:
			has_knife = true
		if collectible.type == COllectible.Type.GUN and not has_gun	:
			has_gun = true
			ammo_left = max_ammo_per_gun
		if collectible.type == COllectible.Type.FOOD:
			print(current_health)
			current_health = health
			print(current_health)
		collectible.queue_free()

func shoot_gun() -> void:
	state = State.SHOOT
	velocity = Vector2.ZERO
	var target_point = heading * (global_position.x + get_viewport_rect().size.x)
	var target = raycast.get_collider()
	if target != null:
		target_point = raycast.get_collision_point()
		target.on_rececive_damage(damage_gun_shot, heading, DamageReceiver.HIType.KNOCKDOWN)
	var weapon_root_position = Vector2(weapon_postion.global_position.x, position.y)
	var weapon_height = -weapon_postion.position.y
	var distance = target_point.x - weapon_postion.global_position.x
	EntityManager.sqawn_shot.emit(weapon_root_position, distance, weapon_height)
