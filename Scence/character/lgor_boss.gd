class_name LgorBoss
extends Character
@export var player : Player
@export var duration_between_attack : int
@export var duration_vulnerable : int
@export var left_wall: AnimatableBody2D 
@export var right_wall: AnimatableBody2D 
const DISTANCE_FROM_PLAYER = 25
const GROUND_FRICTION = 80
var knockback_force = Vector2.ZERO
var death_flag = false
var time_last_attack = Time.get_ticks_msec()
var time_start_vulnerable = Time.get_ticks_msec()
var assigned_door_index = -1


func _process(delta: float) -> void:
	super._process(delta)
	knockback_force = knockback_force.move_toward(Vector2.ZERO, delta * GROUND_FRICTION)

func get_target_destination() -> Vector2:
	var target = Vector2.ZERO
	if position.x < player.position.x:
		target = player.position + Vector2.LEFT * DISTANCE_FROM_PLAYER
	else:
		target = player.position + Vector2.RIGHT * DISTANCE_FROM_PLAYER
	return target

func is_player_within_rang() -> bool:
	var target = get_target_destination()
	return (target - position).length() < 1

func  handle_input() -> void:
	if player != null and can_move():
		if can_attack() and raycast.is_colliding():
			state = State.FLY
			velocity = heading * flight_speed
		else:
			if is_player_within_rang():
				velocity = Vector2.ZERO
				state = State.IDLE
			else:
				var target_distination = get_target_destination()
				var direction = (target_distination - position).normalized()
				velocity = (direction + knockback_force) * speed
				state = State.WALK

func set_heading() -> void:
	if player == null or not can_move():
		return
	heading = Vector2.LEFT if position.x > player.position.x else Vector2.RIGHT

func can_get_hurt() -> bool:
	return true
	
func is_vulnerable() -> bool:
	return state == State.RECOVER

func on_rececive_damage(damage: int, directinon: Vector2, hi_type: DamageReceiver.HIType) -> void:
	if not is_vulnerable():
		knockback_force = directinon * knockback_intensity
		return 
	current_health = clamp(current_health - damage, 0, health)
	if current_health == 0:
		EntityManager.death_enemy.emit(self)
		state = State.FALL
		height_speed = knockdown_intensity
		velocity = directinon * height_speed
		if height <= 0:
			death_flag = true
	else:
		velocity = Vector2.ZERO
		state = State.HURT

func can_attack() -> bool:
	if Time.get_ticks_msec() - time_last_attack < duration_between_attack:
		return false
	return super.can_attack()

func hand_ground() -> void:
	if state == State.GROUND and current_health > 0:
		state = State.RECOVER
		time_start_vulnerable = Time.get_ticks_msec()
	elif state == State.RECOVER and Time.get_ticks_msec() - time_start_vulnerable > duration_vulnerable:
		state = State.IDLE
		time_last_attack = Time.get_ticks_msec()

func on_action_complete() -> void:
	if state == State.HURT:
		state = State.RECOVER
		return
	super.on_action_complete()

func on_emit_damage(damager_receiver: DamageReceiver) -> void:
	damager_receiver.damage_receive.emit(damage, heading, DamageReceiver.HIType.KNOCKDOWN)
	time_last_attack = Time.get_ticks_msec()
	state = State.IDLE

func  is_attacking() -> bool:
	if (heading == Vector2.RIGHT and global_position.x < left_wall.global_position.x + 10) or (heading == Vector2.LEFT and global_position.x > right_wall.global_position.x - 10):
		return false
	return [State.FLY].has(state)

func handle_death(delta: float) -> void:
	if death_flag == true:
		modulate.a -= delta / 2.0
		if modulate.a <= 0:
			queue_free()

		
	
