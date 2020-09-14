extends Node

var puerta_destino = []
var puerta_origen = []
var destino = Vector2()
var origen = Vector2()

func add_puerta(circuito, dst , src):
	#circuitos.append(circuito)
	if !src:
		puerta_destino.append(dst)
	else:
		puerta_origen.append(dst)
#	print("Origenes: ",puerta_origen)
#	print("Destinos: ",puerta_destino)

#func enviar_direccion(circuito):
#	var posicion = circuitos.find(circuito)
#	destino = puerta_destino[posicion]
	
func enviar_direccion(circuito, src):
	if src:
		destino = puerta_destino[circuito-1]
		origen = puerta_origen[circuito-1]
	else:
		destino = puerta_origen[circuito-1]
		origen = puerta_destino[circuito-1]
	#print (destino)

func reset():
	puerta_origen.clear()
	puerta_destino.clear()
	destino = Vector2()
	origen = Vector2()
