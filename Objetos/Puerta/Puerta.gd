extends Area2D

var state
var current_animation
var new_animation

var action = false
var animation_finished = 0
var audio_file = ["res://Assets/Sounds/fx_door/qubodup-DoorOpen03.ogg","res://Assets/Sounds/fx_door/qubodup-DoorClose06.ogg"]

export var source = true
export var cicuito = 0

export var key = false

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
	print(key)
	#Puerta.enviar_direccion(cicuito, source)
	if !key:
		$estados.play("openning")
		play_fx(0)
		Jugador.can_action = true
		action = true
	elif Jugador.keys>0:
		$estados.play("openning")
		play_fx(0)
		Jugador.can_action = true
		action = true
		key=false
		Jugador.keys-=1
	else:
		$aviso/AnimationPlayer.play("entrada")
		


func _on_door_body_exited(body):
	if !key:
		Jugador.can_action=false
		action = false
		$estados.play("clossing")
		play_fx(1)
	else:
		$aviso/AnimationPlayer.play_backwards("entrada")


func _on_estados_animation_finished():
	if $estados.animation == "openning":
		animation_finished = 1
	elif $estados.animation == "clossing":
		animation_finished = 2
		$estados.play("idle")
	pass # Replace with function body.

func play_fx(n):
	var sfx = load(audio_file[n])
	$fx.stream = sfx
	$fx.play()
