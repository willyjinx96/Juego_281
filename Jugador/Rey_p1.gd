extends KinematicBody2D

#maquina de estados (Animacion)
enum {IDLE, RUN, JUMP, FALL, GROUND, ATTACK, HIT, DEAD, DOOR_IN, DOOR_OUT,INVISIBLE}
var state
var current_animation
var new_animation
var n_sfx

var audio_file=["res://Assets/Sounds/Fx_rey/hard-footstep3.wav",
"res://Assets/Sounds/Fx_rey/hard-footstep2.wav",
"res://Assets/Sounds/Fx_rey/jump_1.ogg",
"res://Assets/Sounds/Fx_rey/hurt_1.ogg",
"res://Assets/Sounds/Fx_rey/attack.ogg",
"res://Assets/Sounds/Fx_rey/dead.ogg"]

#fisica de movimientos
const UP = Vector2(0,-1)
var GRAVITY = 15
var ACCELERATION = 70
var MAX_SPEED = 190
var MAX_JUMP_HEIGHT = -350
var MIN_JUMP_HEIGHT = -150
var motion=Vector2()

#variables para accion
signal attack #KEY_C
var attacking = false
var can_attack = true

var can_action = false
#signal action#KEY_X
var action_released =false

var animation_finished=0

#variables danio
var hurt =false

var teleport = false
#variables de vida

export var vidas = 0
var moverse
var input_state

func _ready():
	input_state=true
	movimiento_Personaje(true)
	transition_to(IDLE)
	estado_fisicas(true)
	#Jugador.cambiar_vida(vidas)
	
func _physics_process(delta):
	estados()#Cambia de estados de la animacion
	movimiento(input_state)#habilita o dehabilita la entrada por teclado
	if Jugador.vidas <=0:
		can_attack=false
		estado_fisicas(false)#Habilta/deshabilita la colision y gravedad del cuerpo
		movimiento_Personaje(false)#habilita/deshabilita el move and slide
		#cambiar_estado(false)
	animation_finished=0
	if moverse:
		mover_a(motion)#mueve el cuerpo a una determinada posicion
	elif hurt:
		Jugador.invulnerable = true
		retroceso()#hace un empuje hacia atras
	elif teleport:
		#teletransportar_a(Vector2(999,431))
		teletransportar_a(Puerta.destino)
		#$mover.play("puertas")

func transition_to(new_state):
	state=new_state
	
	match state:
		IDLE:
			new_animation ="idle"
			n_sfx=-1
		RUN:
			new_animation ="run"
			n_sfx=1
		JUMP:
			new_animation ="jump"
			n_sfx=2
		FALL:
			new_animation ="fall"
			n_sfx=-1
		GROUND:
			new_animation="ground"
			n_sfx=-1
		ATTACK:
			new_animation ="attack"
			n_sfx=4
		HIT:
			new_animation ="hit"
			n_sfx=3
		DEAD:
			new_animation ="dead"
			n_sfx=5
		DOOR_IN:
			new_animation ="door_in"
			n_sfx=-1
		DOOR_OUT:
			new_animation ="door_out"
			n_sfx=-1
		INVISIBLE:
			new_animation = "invisible"
			n_sfx=-1
func _on_movement_animation_finished():
	if $movement.animation== "attack":
		animation_finished=1
		attacking=false
		movimiento_Personaje(true)
		$ataque/CollisionShape2D.disabled=true
	if $movement.animation== "hit":
		animation_finished=2
		hurt=false
		motion.x=0
		cambiar_estado(true)
		movimiento_Personaje(true)
		Jugador.invulnerable = false
	if $movement.animation == "door_in":
		animation_finished = 3
		action_released=false
		teleport = true
	if $movement.animation == "door_out":
		animation_finished=4
		cambiar_estado(true)
		movimiento(true)
		movimiento_Personaje(true)
		teleport = false
		estado_fisicas(true)
		Jugador.invulnerable = false
	if $movement.animation=="dead":
		movimiento(false)
		#estado_fisicas(false)
		#pausar()
	if $movement.animation == "invisible":
		animation_finished = 5
		teleport = false


func _on_KinematicBody2D_attack():
	can_attack=false
	$tiempo_de_ataque.start()
	$ataque/CollisionShape2D.disabled=false
	attacking=true
	Jugador.emit_signal("attack")

func pausar():
	get_tree().paused=true

func damage():
	if not Jugador.invulnerable:
		Jugador.vidas -= 1
		
		hurt = true
		cambiar_estado(false)
		movimiento_Personaje(false)
		Jugador.emit_signal("hit")

func estados():
	if current_animation != new_animation:
		current_animation= new_animation
		$movement.play(current_animation)
		$sfx/AudioStreamPlayer.stop()
		if n_sfx !=-1:
			var sfx=load(audio_file[n_sfx])
			$sfx/AudioStreamPlayer.stream =sfx
			$sfx/AudioStreamPlayer.play()

#estados movimiento
	var running = (Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left"))
	var not_running = (Input.is_action_just_released("ui_right") or Input.is_action_just_released("ui_left"))
	
	if state == IDLE and running:
		transition_to(RUN)
	if state == RUN and not_running:
		transition_to(IDLE)
	if state in [IDLE,RUN] and motion.y<0:
		transition_to(JUMP)
	if state==JUMP and motion.y>=0:
		transition_to(FALL)
	if state==FALL and is_on_floor():
		transition_to(GROUND)
	if state==GROUND and is_on_floor():
		transition_to(IDLE)
	if state==RUN and is_on_wall():
		transition_to(IDLE)
	if state==RUN and !is_on_floor():
		transition_to(FALL)

#estados ataque
	if state in [RUN, IDLE] and attacking:
		transition_to(ATTACK)
	if state in [JUMP, FALL] and attacking:
		transition_to(ATTACK)
	if state == ATTACK and animation_finished==1 and is_on_floor():
		transition_to(IDLE)
	if state == ATTACK and animation_finished==1 and motion.y<0:
		transition_to(JUMP)
	if state == ATTACK and animation_finished==1 and motion.y>=0:
		transition_to(FALL)
	
#estados accion
	if state in [IDLE, RUN] and action_released:
		transition_to(DOOR_IN)
	if state == DOOR_IN and animation_finished==3:
		transition_to(INVISIBLE)
	if state == INVISIBLE and animation_finished ==5:
		transition_to(DOOR_OUT)
	if state == DOOR_OUT and animation_finished==4:
		transition_to(IDLE)
	#if state == DOOR_OUT and animation_finished==4 and running:
		#transition_to(RUN)

#estados danio
	if state in [IDLE, RUN, JUMP, FALL] and hurt:
		transition_to(HIT)
	if state == HIT and is_on_floor() and animation_finished==2:
		transition_to(IDLE)
	if state==HIT and !is_on_floor() and animation_finished==2:
		transition_to(FALL)
	if state in [HIT,IDLE,JUMP,FALL] and Jugador.vidas<=0 and animation_finished==2:
		transition_to(DEAD)

#WILLY ESTO HICE PARA PROBAR EL LLAMADO DEL CERDITO AL HACERLE DAÑO :V
func _on_ataque_body_entered(body):
	body.hacerDanio(global_position.x)

func movimiento_Personaje(estado):
	moverse=estado

func cambiar_estado(estado):
	input_state=estado

func mover_a(posicion):
	motion = move_and_slide(posicion,UP)

func retroceso():
	if $movement.flip_h==true:
		mover_a(Vector2(100,0))
	else:
		mover_a(Vector2(-100,0))

func estado_fisicas(estado):
	if estado:
		$ataque/CollisionShape2D.disabled=true
		$CollisionShape2D.disabled=false
		GRAVITY = 15
		ACCELERATION = 70
		MAX_SPEED = 190
		MAX_JUMP_HEIGHT = -350
		MIN_JUMP_HEIGHT = -150
	else:
		$CollisionShape2D.disabled=true
		GRAVITY = 0
		ACCELERATION = 0
		MAX_SPEED = 0
		MAX_JUMP_HEIGHT = 0
		MIN_JUMP_HEIGHT = 0

func restaurar_vida(posicion, n_vidas):
	Jugador.vidas=n_vidas
	mover_a(posicion)


func movimiento(estado_entrada):
	if estado_entrada:
		motion.y += GRAVITY
		var friction =false
		#Para movimiento derecha e izquierda
		
		if Input.is_action_pressed("ui_right"):
			#print("-->")
			$movement.flip_h=false
			$movement.position.x=0
			$ataque/CollisionShape2D.position.x=10.709
			motion.x =min(motion.x+ACCELERATION, MAX_SPEED)
		elif Input.is_action_pressed("ui_left"):
			#print("<--")
			$movement.flip_h=true
			$movement.position.x=-15
			$ataque/CollisionShape2D.position.x=-25
			motion.x =max(motion.x - ACCELERATION, -MAX_SPEED)
		else:
			friction =true
		
		#Para el salto
		if is_on_floor():
			if Input.is_action_pressed("ui_up"):
				motion.y =MAX_JUMP_HEIGHT
			if Input.action_release("ui_up") and motion.y <0:
				motion.y =MIN_JUMP_HEIGHT
			if friction == true:
				motion.x = lerp(motion.x, 0 , 0.20)
		elif friction == true:
				motion.x = lerp(motion.x, 0 , 0.05)
		
		#Para ataque
		if Input.is_action_just_pressed("ui_page_up") and can_attack:
			Jugador.can_action = false
			emit_signal("attack")
			if is_on_floor():
				movimiento_Personaje(false)
			#print("ataco....")
		
		#Para la accion
		if Input.is_action_just_pressed("ui_page_down") and Jugador.can_action and is_on_floor():
			#transition_to(DOOR_IN)
			Jugador.invulnerable = true
			action_released=true
			cambiar_estado(false)
			movimiento(false)
			movimiento_Personaje(false)
			teletransportar_a(Puerta.origen)


func _on_tiempo_de_ataque_timeout():
	can_attack=true
	
func teletransportar_a(posicion):
	#mover_a(posicion)
	#movimiento_Personaje(true)
	global_position = posicion
	#estado_fisicas(false)
	#$movement.play("invisible")
	pass
