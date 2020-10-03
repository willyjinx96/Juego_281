extends Node

var posicion
var vidas = 5
var can_action
var invulnerable
signal hit 
signal attack
signal heart_taken
var diamnates = 0
var keys = 0

func _ready():
	pass

func cambiar_vida(new_vidas):
	vidas = new_vidas
