extends Node2D

export(String, MULTILINE) var text = "TEXTO PRUEBA"
var dictionary_letters = {}

func _ready():
	get_dictionary()
	pass

func get_dictionary():
	var str_path = "res://Assets/Sprites/17-GUI/Big Text/"
	var char_path = "a"
	for i in range(1,26):
		dictionary_letters[str_path+str(i)+".png"] = char_path
		pass
	print(dictionary_letters)
	pass
