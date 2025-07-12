class_name  SoundManager
extends Node
@onready var sounds: Array[AudioStreamPlayer] = [$click, $"eat-food", $gogogo, $grunt, $gunshot,  $"hit-1", $"hit-2", $"knife-hit", $miss]
enum  Sound {CLICK, FOOD, GO, GRUNT, GUN, HIT1, HIT2, KNIFE, MISS}


func play(sfx: Sound, tweak_pitch: bool = false) -> void:
	var added_pitch = 0
	if tweak_pitch:
		added_pitch = randf_range(-0.3, 0.3)
	sounds[sfx as int].pitch_scale = 1 + added_pitch
	sounds[sfx as int].play()
