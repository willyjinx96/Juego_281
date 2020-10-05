extends Node2D


func _ready():
	pass


func _on_volver_pressed():
	get_tree().change_scene("res://GUI/Main Menu/main_menu.tscn")
	queue_free()
	pass # Replace with function body.
