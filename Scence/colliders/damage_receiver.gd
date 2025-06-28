class_name DamageReceiver
extends Area2D

# 定义一个信号，该信号会作为伤害接收器接受收到伤害时的信号，它将在父节点被调用
signal damage_receive(damage: int, direction: Vector2)
