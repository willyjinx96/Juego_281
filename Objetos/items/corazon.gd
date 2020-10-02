extends Area2D


func _ready():
	pass
	
func _on_Area2D_body_entered(body):
	if body.name == "Rey_p1":
		if Jugador.vidas <7:
			Jugador.emit_signal("heart_taken")
			Jugador.vidas +=1
		$corazon.play("taken")
	pass # Replace with function body.


func _on_corazon_animation_finished():
	if $corazon.animation == "taken":
		queue_free()
	pass # Replace with function body.
