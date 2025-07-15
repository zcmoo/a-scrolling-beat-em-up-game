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
		setup_and_play(autoplay_music)

func play(music: Music, loop: bool = true) -> void:
	if music_stream_player.is_node_ready():	
		setup_and_play(MUSIC_MAP[music], loop)
	else:
		autoplay_music = MUSIC_MAP[music]

func setup_and_play(stream: AudioStream, loop: bool = true) -> void:
	music_stream_player.stream = stream
	stream.loop = loop
	music_stream_player.play()
