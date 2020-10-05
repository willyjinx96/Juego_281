extends Area2D


func _ready():
	pass


func _on_Area2D_body_entered(body):
	if body.name == "Rey_p1":
		$AnimatedSprite.play("taken")
		$fx.play()
		Jugador.score += 5
	pass # Replace with function body.


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "taken":
		Jugador.diamnates +=1
		queue_free()
	pass # Replace with function body.
