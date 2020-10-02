extends AnimatedSprite


func _ready():
	pass

func _on_corazon_animation_finished():
	if animation=="heart_lost":
		queue_free()
	pass # Replace with function body.
