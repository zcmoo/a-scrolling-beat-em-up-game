class_name Player
extends Character

# 处理键盘输入
func handle_input() -> void:
	var direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	velocity = direction * speed
	if can_attack() and Input.is_action_just_pressed("attack"):
		state = State.ATTACK
	if can_jump() and Input.is_action_just_pressed("jump"):
		state = State.TAKE_OFF
	if can_jump_kick() and Input.is_action_just_pressed("attack"):
		state = State.JUMPKICK
