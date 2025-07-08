class_name BaiscEnemy
extends Character
@export var player: Player
@export var duration_between_hit : int
@export var duration_prop_hit : int
@export var duration_between_range_attack : int
@export var duration_prep_range_attack : int
var player_slot : EnemySlot = null
var has_slot : bool = false
var time_since_last_hit = Time.get_ticks_msec()
var time_since_prop_hit = Time.get_ticks_msec()
var time_since_prep_range_attack = Time.get_ticks_msec()
var time_since_last_range_attack = Time.get_ticks_msec()
const EDGE_SCREEN_BUFFER = 10

func _ready() -> void:
	super._ready()
	anim_attack = ["punch", "punch_alt"]
# 重写父节点的函数处理小怪跟随玩家的给定位置移动
func goto_melee_postion() -> void:
	if can_pick_up():
		state = State.PICK_UP
		if has_slot:
			player.free_slot(self)
	elif player != null and can_move():
		if player_slot == null:
			player_slot = player.reserve_slot(self)
		if player_slot != null:
			var direction = (player_slot.global_position - global_position).normalized()
			if is_player_within_rang():
				velocity = Vector2.ZERO
				if can_attack():
					state = State.PREP_ATTACK
					time_since_prop_hit = Time.get_ticks_msec()
			else:
				velocity = direction * speed
# 重写父节点的函数让敌人死后让出给定位置
func on_rececive_damage(damage: int, directinon: Vector2, hi_type: DamageReceiver.HIType) -> void:
	super.on_rececive_damage(damage, directinon, hi_type)
	if current_health <= 0:
		player.free_slot(self)
		EntityManager.death_enemy.emit(self)
# 重写父节点的设置朝向的函数让敌人朝正确方向
func set_heading() -> void:
	if player == null or not can_move():
		return
	heading = Vector2.LEFT if position.x > player.position.x else Vector2.RIGHT

func is_player_within_rang() -> bool:
	return (player_slot.global_position - global_position).length() < 3

func can_attack() -> bool:
	if Time.get_ticks_msec() - time_since_last_hit < duration_between_hit:
		return false
	return super.can_attack()
	
func handle_prep_attack() -> void:
	if state == State.PREP_ATTACK and (Time.get_ticks_msec() - time_since_prop_hit > duration_prop_hit):
		state = State.ATTACK
		time_since_last_hit = Time.get_ticks_msec()
		anim_attack.shuffle()

func goto_range_position() -> void:
	var camera = get_viewport().get_camera_2d()
	var screen_width = get_viewport_rect().size.x
	var screen_left_edge = camera.position.x - screen_width / 2
	var screen_right_edge = camera.position.x + screen_width / 2
	var left_destinate = Vector2(screen_left_edge + EDGE_SCREEN_BUFFER, player.position.y)
	var right_destinate = Vector2(screen_right_edge - EDGE_SCREEN_BUFFER, player.position.y)
	var closest_destinate = Vector2.ZERO
	if (left_destinate - position).length() < (right_destinate - position).length():
		closest_destinate = left_destinate
	else:
		closest_destinate = right_destinate
	if (closest_destinate - position).length() < 1:
		velocity = Vector2.ZERO
	else:
		velocity = (closest_destinate - position).normalized() * speed
	if can_range_attack() and has_knife and raycast.is_colliding():
		velocity = Vector2.ZERO
		state = State.THROW
		time_since_knife_dismiss = Time.get_ticks_msec()
		time_since_last_range_attack = Time.get_ticks_msec()
	if can_range_attack() and has_gun and raycast.is_colliding():
		velocity = Vector2.ZERO
		state = State.PRE_SHOOT
		time_since_prep_range_attack = Time.get_ticks_msec()

func handle_input() -> void:
	if health == 800:
		print(current_health)
	if player != null and can_move():
		if can_resqawn_knives or has_knife or has_gun:
			goto_range_position()
		else:
			goto_melee_postion()

func can_range_attack() -> bool:
	if Time.get_ticks_msec() - time_since_last_range_attack < duration_between_range_attack:
		return false
	return super.can_attack()

func handle_pre_shoot() -> void:
	if state == State.PRE_SHOOT and (Time.get_ticks_msec() - time_since_prep_range_attack > duration_prep_range_attack):
		shoot_gun()
		time_since_last_range_attack = Time.get_ticks_msec()
