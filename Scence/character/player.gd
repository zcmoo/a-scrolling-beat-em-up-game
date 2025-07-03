class_name Player
extends Character
@onready var enemy_slots : Array = $EnemySlots.get_children()

func _ready() -> void:
	super._ready()
	anim_attack = ["punch", "punch_alt", "kick", "round_kick"]
# 处理键盘玩家键盘输入并根据键盘输入切换状态
func handle_input() -> void:
	if can_move():
		var direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
		velocity = direction * speed
	if can_attack() and Input.is_action_just_pressed("attack"):
		if has_knife:
			state = State.THROW
		elif has_gun:
			state = State.SHOOT
		else:
			if can_pick_up():
				state = State.PICK_UP
			else:
				state = State.ATTACK
				if is_last_hit_successful:
					attack_combo_index = (attack_combo_index + 1) % anim_attack.size()
					is_last_hit_successful = false
				else:
					attack_combo_index = 0
	if can_jump() and Input.is_action_just_pressed("jump"):
		state = State.TAKE_OFF
	if can_jump_kick() and Input.is_action_just_pressed("attack"):
		state = State.JUMPKICK

# 给离给定位置最近的敌人占一个位置并返回这个位置
func reserve_slot(enemy: BaiscEnemy) -> EnemySlot:
	var available_slots = enemy_slots.filter(func(slot: EnemySlot): return slot.is_free())
	if available_slots.size() == 0:
		return null
	available_slots.sort_custom(func(a: EnemySlot, b: EnemySlot):
		var dist_a = (enemy.global_position - a.global_position).length()
		var dist_b = (enemy.global_position - b.global_position).length()
		return dist_a < dist_b)
	var closest_slot = available_slots[0]
	closest_slot.occupy(enemy)  
	enemy.has_slot = true
	return closest_slot
# 找到并释放被指定敌人占用的位置（敌人已死亡）
func free_slot(enemy: BaiscEnemy) -> void:
	var target_slots = enemy_slots.filter(func(slot: EnemySlot): return slot.occupant == enemy)
	if target_slots.size() == 1:
		target_slots[0].free_up()
# 设置玩家的朝向
func set_heading() -> void:
	if velocity.x > 0:
		heading = Vector2.RIGHT
	if velocity.x < 0:
		heading = Vector2.LEFT
