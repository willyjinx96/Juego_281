extends CanvasLayer

onready var game_over=preload("res://GUI/Game Over/game_over_scene.tscn")
onready var win=preload("res://GUI/Win/win_screen.tscn")

func _ready():
	$saving.play("idle")
	Jugador.connect("game_over",self,"game_over_screen")
	InGame.connect("saving",self,"save_animation")
	InGame.connect("final",self,"win")
	pass

func _process(delta):
	$contador_diamantes/Label.text=str(Jugador.diamnates)
	$contador_llave/Label2.text=str(Jugador.keys)
	$score/Label.text = str(Jugador.score)

func game_over_screen():
	get_tree().get_nodes_in_group("gui")[0].add_child(game_over.instance())
	
func save_animation():
	$saving.play("saving")


func _on_saving_animation_finished():
	if $saving.animation == "saving":
		$saving.play("idle")
	pass # Replace with function body.

func win():
	get_tree().get_nodes_in_group("gui")[0].add_child(win.instance())
