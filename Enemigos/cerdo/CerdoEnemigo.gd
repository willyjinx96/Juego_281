extends KinematicBody2D

var accionSwIzquierda=true
var esEnemigoDetectado=false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	pass


func maquinaDeEstado():
	if accionSwIzquierda && !esEnemigoDetectado:
		$AnimatedSprite.flip_h=accionSwIzquierda
		$AnimatedSprite.play("caminar")
		
