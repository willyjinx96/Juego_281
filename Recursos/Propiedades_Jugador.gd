extends Node

var posicion
var vidas = 5
var can_action
var invulnerable
signal hit 
signal attack

func _ready():
	pass

func cambiar_vida(new_vidas):
	vidas = new_vidas
