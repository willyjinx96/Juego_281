extends Node2D


func _ready():
	Music.change_music(4)
	$menu/max_score/max_score.text = str(Jugador.max_score)
	$menu/diamantes/diamantes.text = str(Jugador.diamnates)
	$menu/score/score.text = str(Jugador.score)
	pass


func _on_menu_pressed():
	get_tree().change_scene("res://GUI/Main Menu/main_menu.tscn")
	Jugador.diamnates = 0
	Jugador.vida = Jugador.vidas
	Jugador.win = false
	InGame.saving_position = null
	Jugador.score = 0
	queue_free()
	pass # Replace with function body.


func _on_volver_pressed():
	get_tree().reload_current_scene()
	Jugador.diamnates = 0
	Jugador.vida = Jugador.vidas
	Jugador.win = false
	InGame.saving_position = null
	Jugador.score = 0
	queue_free()
	pass # Replace with function body.


func _on_salir_pressed():
	get_tree().quit()
	pass # Replace with function body.
