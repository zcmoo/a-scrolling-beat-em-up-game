class_name FickerTextureRect
extends TextureRect
const DURATION_FLICKER = 200
const total_flickers = 3
var is_flickering = false
var flicker_left = 0
var time_start_last_flicker = Time.get_ticks_msec()
var image: Texture2D = null


func _ready() -> void:
	image = texture
	texture = null

func start_flickering() -> void:
	flicker_left = total_flickers
	is_flickering = true
	time_start_last_flicker = Time.get_ticks_msec()
	SoundPlayer.play(SoundManager.Sound.GO)

func _process(delta: float) -> void:
	if is_flickering and (Time.get_ticks_msec() - time_start_last_flicker) > DURATION_FLICKER:
		if texture == null:
			if flicker_left == 0:
				is_flickering = false
			else:
				flicker_left -= 1
				texture = image
		else:
			texture = null
		time_start_last_flicker = Time.get_ticks_msec()
