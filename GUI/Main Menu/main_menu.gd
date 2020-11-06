extends Node2D


func _ready():
	Music.change_music(2)
	OS.center_window()
	pass


func _on_salir_pressed():
	get_tree().quit()
	pass # Replace with function body.


func _on_jugar_pressed():
	get_tree().change_scene("res://Levels/escenarios/Level_1.tscn")
	queue_free()
	pass # Replace with function body.


func _on_info_pressed():
	get_tree().change_scene("res://GUI/Info/Info.tscn")
	queue_free()
	pass # Replace with function body.


func _on_tutorial_pressed():
	get_tree().change_scene("res://GUI/tutorial/tutorial.tscn")
	queue_free()
	pass # Replace with function body.
