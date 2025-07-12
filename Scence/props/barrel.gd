extends StaticBody2D
@export var knockback_intensity : float
@export var content_type : COllectible.Type
@onready var damage_receiver = %DamageReceiver
@onready var sprite = %Sprite2D
var velocity = Vector2.ZERO
enum State {IDLE, DESTORYED}
var state = State.IDLE
var height = 0.0
var height_speed = 0.0
const GRAVITY = 500


# 节点生成后绑定当伤害接受器（子节点）发送信号时的回调函数，并将接收的信号作为参数传递给改回调函数
func _ready() -> void:
	damage_receiver.damage_receive.connect(on_rececive_damage.bind())
# 游戏主循环里处理油箱运动
func _process(delta: float) -> void:
	position += velocity * delta
	sprite.position = Vector2.UP * height
	handle_air_time(delta)
# 油桶对象接收子节点伤害接受器传来的信号后将要执行的回调函数，该函数会初始化油箱初始高度速度和水平速度
func on_rececive_damage(damage: int, direction: Vector2, hi_type: DamageReceiver.HIType) -> void:
	if state == State.IDLE:
		sprite.frame = 1
		height_speed = knockback_intensity * 2
		state = State.DESTORYED
		velocity = direction * knockback_intensity
		EntityManager.sqawn_collectible.emit(content_type, COllectible.State.FALL, global_position, Vector2.ZERO, 0.0, false)
		SoundPlayer.play(SoundManager.Sound.HIT1, true)
# 处理油箱在空气中受到重力影响并调整可见度，如果油箱落地将他从场景树中移除
func handle_air_time(delta: float) -> void:
	if state == State.DESTORYED:
		modulate.a -= delta
		height += height_speed * delta
		if height < 0:
			height = 0
			queue_free()
		else:
			height_speed -= GRAVITY * delta
			
