extends Node

var posicion
var vidas = 5
var vida = vidas
var can_action
var invulnerable
signal hit 
signal attack
signal heart_taken
var diamnates = 0
var keys = 0

var win = false

signal game_over

var score = 0
var max_score = 0 
signal reiniciar
	
func cambiar_vida(new_vidas):
	vidas = new_vidas

func _process(delta):
	if score >= max_score:
		max_score = score
