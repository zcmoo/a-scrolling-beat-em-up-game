class_name BaiscEnemy
extends Character
@export var player: Player
var player_slot : EnemySlot = null
var has_slot : bool = false

# 重写父节点的函数处理小怪跟随玩家的给定位置移动
func handle_input() -> void:
	if player != null and can_move():
		if player_slot == null:
			player_slot = player.reserve_slot(self)
		if player_slot != null:
			var direction = (player_slot.global_position - global_position).normalized()
			if (player_slot.global_position - global_position).length() < 1:
				velocity = Vector2.ZERO
			else:
				velocity = direction * speed
# 重写父节点的函数让敌人死后让出给定位置
func on_rececive_damage(damage: int, directinon: Vector2, hi_type: DamageReceiver.HIType) -> void:
	super.on_rececive_damage(damage, directinon, hi_type)
	if !self.has_slot:
		state = State.IDLE
		velocity = Vector2.ZERO
	if current_health <= 0:
		player.free_slot(self)
# 重写父节点的设置朝向的函数让敌人朝正确方向
func set_heading() -> void:
	if player == null:
		return
	heading = Vector2.LEFT if position.x > player.position.x else Vector2.RIGHT
