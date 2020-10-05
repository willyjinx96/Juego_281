extends AudioStreamPlayer2D

var audio_file = ["res://Assets/Sounds/Music/TownTheme.ogg",
"res://Assets/Sounds/Music/Game Over - Repeating Dream.ogg",
"res://Assets/Sounds/Music/Winds Of Stories.ogg",
"res://Assets/Sounds/Music/Woodland Fantasy.ogg"]

func _ready():
	pass

func change_music(n):
	
	var musica= load(audio_file[n])
	if !stream == musica:
		stop()
		stream = musica
		play()
