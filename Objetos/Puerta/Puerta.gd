extends Area2D

var state
var current_animation
var new_animation

var action = false
var animation_finished = 0

export var source = true
export var cicuito = 0

enum {IDLE, OPENNING, CLOSSING}

func _ready():
	transtion_to(IDLE)
	Puerta.add_puerta(cicuito, global_position+Vector2(7,14), source)
	pass

func _physics_process(delta):
	if Input.is_action_pressed("ui_page_down") and action:
		if cicuito !=0:
			Puerta.enviar_direccion(cicuito, source)
		else:
			print("Otro destino :v")
#		#action = true
#		#$estados.play("openning")
#		transtion_to(OPENNING)
##		$CollisionShape2D.disabled=false

func transtion_to(new_state):
	state=new_state
	
	match state:
		IDLE:
			new_animation ="idle"
			pass
		OPENNING:
			new_animation="openning"
			pass
		CLOSSING:
			new_animation="clossing"
			pass

func estado():
	if current_animation != new_animation:
		current_animation= new_animation
		$estados.play(current_animation)

#	if state == IDLE and action:
#		transtion_to(OPENNING)
	if  state == OPENNING  and animation_finished ==1:
		transtion_to(CLOSSING)
	if state == CLOSSING and animation_finished ==2:
		transtion_to(IDLE)

func _on_door_body_entered(body):
	#Puerta.enviar_direccion(cicuito, source)
	$estados.play("openning")
	Jugador.can_action = true
	action = true


func _on_door_body_exited(body):
	Jugador.can_action=false
	action = false
	$estados.play("clossing")


func _on_estados_animation_finished():
	if $estados.animation == "openning":
		animation_finished = 1
	elif $estados.animation == "clossing":
		animation_finished = 2
		$estados.play("idle")
	pass # Replace with function body.
