class_name DamageReceiver
extends Area2D
enum HIType {NOMAL, KNOCKDOWN, POWER}

# 定义一个信号，该信号会作为伤害接收器接受收到伤害时的信号，它将在父节点(被伤害的对象)被调用
signal damage_receive(damage: int, direction: Vector2, hi_type: HIType)
