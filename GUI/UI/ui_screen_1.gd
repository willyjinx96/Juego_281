extends CanvasLayer

onready var game_over=preload("res://GUI/Game Over/game_over_scene.tscn")

func _ready():
	Jugador.connect("game_over",self,"game_over_screen")
	pass

func _process(delta):
	$contador_diamantes/Label.text=str(Jugador.diamnates)
	$contador_llave/Label2.text=str(Jugador.keys)
	$score/Label.text = str(Jugador.score)

func game_over_screen():
	get_tree().get_nodes_in_group("gui")[0].add_child(game_over.instance())
