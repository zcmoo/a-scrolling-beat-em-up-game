extends Camera2D

# 缩放镜头
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("camera_scale"):
		set_zoom(Vector2(0.6, 0.6))
		return
	if event.is_action_released("camera_scale"):
		set_zoom(Vector2(1, 1))
		return		
