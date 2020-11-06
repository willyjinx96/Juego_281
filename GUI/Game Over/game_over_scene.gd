extends Node2D

var boton = 0#1 reiniciar #2 volver menu
func _ready():
	Music.change_music(1)
	$gui/score/text_score.text = str(Jugador.score)
	$gui/score/text_max_score.text = str(Jugador.max_score)
	$gui/info_diamantes/cant_diamantes.text = str(Jugador.diamnates)
	pass


func _on_boton_salir_pressed():
	get_tree().quit()
	pass # Replace with function body.


func _on_menu_pressed():
	boton =2
	$animacion.play_backwards("cargar")
	pass # Replace with function body.


func _on_reiniciar_pressed():
	boton=1
	$animacion.play_backwards("cargar")
	pass # Replace with function body.


func _on_animacion_animation_finished(anim_name):
	if boton ==1:
		print("reiniciando nivel..")
		get_tree().reload_current_scene()
		#get_tree().change_scene("res://Levels/Level_1.tscn")
		Jugador.vida = Jugador.vidas
		Jugador.score = 0
		Jugador.keys = 0
		Puerta.reset()
		#Jugador.emit_signal("reiniciar")
		queue_free()
	elif boton ==2 :
		get_tree().change_scene("res://GUI/Main Menu/main_menu.tscn")
		print("volviendo al menu...")
		Jugador.vida = Jugador.vidas
		Jugador.score = 0
		Jugador.diamnates = 0
		Jugador.keys = 0
		queue_free()
	pass # Replace with function body.
