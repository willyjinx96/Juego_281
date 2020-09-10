extends Node

var puerta_destino = []
#var puerta_origen = []
var circuitos= []

var destino = Vector2()

func add_puerta(circuito, dst , src):
	#puerta_origen.append(src)
	if !src:
		circuitos.append(circuito)
		puerta_destino.append(dst)

func enviar_direccion(circuito):
	var posicion = circuitos.find(circuito)
	destino = puerta_destino[posicion]
