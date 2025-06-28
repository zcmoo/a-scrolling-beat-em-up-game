class_name EnemySlot
extends Node2D
var occupant : BaiscEnemy = null

# 判断该位置是否被占用的api并返回bool值
func is_free() -> bool:
	return occupant == null
# 将该位置让出来的api
func free_up() -> void:
	occupant = null
# 规定谁占用该位置的api
func occupy(enemy: BaiscEnemy) -> void:
	occupant = enemy
