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
	pass

func _physics_process(delta):
	var x =global_position.x + 7
	var y =global_position.y +14
	Puerta.add_puerta(cicuito, Vector2(x,y), source)
	pass
#	if Input.is_action_pressed("ui_page_down") and action:
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
	$estados.play("openning")
	Puerta.enviar_direccion(cicuito)
	Jugador.can_action = true
	action = true
	#if vuelta %2==0 and ida == vuelta-1:
		#Puerta.puerta_destino = global_position
	pass # Replace with function body.


func _on_door_body_exited(body):
	var x =global_position.x + 7
	var y =global_position.y +14
	Puerta.add_puerta(cicuito, Vector2(x,y), not source)
	source = false
	Jugador.can_action=false
	action =false
	$estados.play("clossing")
	#transtion_to(CLOSSING)
	#$CollisionShape2D.disabled=true


func _on_estados_animation_finished():
	if $estados.animation == "openning":
		animation_finished = 1
	elif $estados.animation == "clossing":
		animation_finished = 2
	pass # Replace with function body.
