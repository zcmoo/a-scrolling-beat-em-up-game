class_name MusicManager
extends Node2D
@onready var music_stream_player: AudioStreamPlayer = $AudioStreamPlayer
var autoplay_music: AudioStream = null
enum Music {INTRO, MENU, STAGE1, STAGE2}
const MUSIC_MAP: Dictionary = {
	Music.INTRO: preload("res://assets/assets/music/intro.mp3"),
	Music.MENU: preload("res://assets/assets/music/menu.mp3"),
	Music.STAGE1: preload("res://assets/assets/music/stage-01.mp3"),
	Music.STAGE2: preload("res://assets/assets/music/stage-02.mp3"),
}


func _ready() -> void:
	if autoplay_music != null:
		music_stream_player.stream = autoplay_music
		music_stream_player.play()

func play(music: Music) -> void:
	if music_stream_player.is_node_ready():	
		music_stream_player.stream = MUSIC_MAP[music]
		music_stream_player.play()
	else:
		autoplay_music = MUSIC_MAP[music]
