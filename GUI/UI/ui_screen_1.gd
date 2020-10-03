extends CanvasLayer

func _ready():
	pass

func _process(delta):
	$contador_diamantes/Label.text=str(Jugador.diamnates)
	$contador_llave/Label2.text=str(Jugador.keys)
