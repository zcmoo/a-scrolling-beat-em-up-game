class_name Camera
extends Camera2D
const DURATION_SHAKE = 50
const SHAKE_INTENSITY = 1
var is_shaking = false
var time_start_shaking = Time.get_ticks_msec()

# 绑定信号
func _init() -> void:
	DamageManager.heavy_below_rececived.connect(on_heavy_below_received.bind())
# 缩放镜头
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("camera_scale"):
		set_zoom(Vector2(0.6, 0.6))
		return
	if event.is_action_released("camera_scale"):
		set_zoom(Vector2(1, 1))
		return		

func	 on_heavy_below_received() -> void:
	is_shaking = true
	time_start_shaking = Time.get_ticks_msec()

func _process(delta: float) -> void:
	if is_shaking and (Time.get_ticks_msec() - time_start_shaking) < DURATION_SHAKE:
		offset = Vector2(randi_range(-SHAKE_INTENSITY, SHAKE_INTENSITY), randi_range(-SHAKE_INTENSITY, SHAKE_INTENSITY))
	else:
		offset = Vector2.ZERO
		is_shaking = false
