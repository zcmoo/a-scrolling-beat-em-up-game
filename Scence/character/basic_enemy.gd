class_name BaiscEnemy
extends Character
@export var player: Player
var player_slot : EnemySlot = null

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
	if current_health <= 0:
		player.free_slot(self)
		queue_free()
		print("killed")
		
