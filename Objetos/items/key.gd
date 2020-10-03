extends Area2D


func _ready():
	pass


func _on_key_body_entered(body):
	if body.name == "Rey_p1":
		Jugador.keys += 1
		$AnimatedSprite.play("pickup")


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "pickup":
		queue_free()
	pass # Replace with function body.
