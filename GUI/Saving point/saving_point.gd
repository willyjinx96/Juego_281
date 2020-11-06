extends Area2D

var activo = true
func _ready():
	pass
func _on_saving_point_body_exited(body):
	activo = false
	queue_free()
	pass # Replace with function body.


func _on_saving_point_body_entered(body):
	if body.name == "Rey_p1" and activo:
		InGame.saving_position = Jugador.posicion
		InGame.emit_signal("saving")
		print("Guardando posicion: ",InGame.saving_position)
	pass # Replace with function body.
