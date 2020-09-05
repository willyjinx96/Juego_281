extends KinematicBody2D

#maquina de estados (Animacion)
enum {IDLE, RUN, JUMP, FALL, GROUND, ATTACK, HIT, DEAD, DOOR_IN, DOOR_OUT}
var state
var current_animation
var new_animation

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
signal hit
var hurt =false

#variables de vida

export var vidas = 6000
#var dead =false
var moverse
var input_state

func _ready():
	input_state=true
	movimiento_Personaje(true)
	transition_to(IDLE)
	estado_fisicas(true)
	
func _physics_process(delta):
	cambiar_label()
	estados()
	movimiento(input_state)
	if vidas <=0:
		can_attack=false
		estado_fisicas(false)
		movimiento_Personaje(false)
		#cambiar_estado(false)
	animation_finished=0
	if moverse:
		mover_a(motion)
	if hurt:
		retroceso()


func transition_to(new_state):
	state=new_state
	
	match state:
		IDLE:
			new_animation ="idle"
		RUN:
			new_animation ="run"
		JUMP:
			new_animation ="jump"
		FALL:
			new_animation ="fall"
		GROUND:
			new_animation="ground"
		ATTACK:
			new_animation ="attack"
		HIT:
			new_animation ="hit"
		DEAD:
			new_animation ="dead"
		DOOR_IN:
			new_animation ="door_in"
		DOOR_OUT:
			new_animation ="door_out"
	
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
	if $movement.animation == "door_in":
		animation_finished = 3
		action_released=false
	if $movement.animation == "door_out":
		animation_finished=4
		cambiar_estado(true)
		movimiento(true)
		movimiento_Personaje(true)
	if $movement.animation=="dead":
		#estado_fisicas(false)
		pausar()

func _on_KinematicBody2D_attack():
	can_attack=false
	$tiempo_de_ataque.start()
	$ataque/CollisionShape2D.disabled=false
	attacking=true

func pausar():
	get_tree().paused=true

func damage():
	vidas -=1
	hurt =true
	cambiar_estado(false)
	movimiento_Personaje(false)

func estados():
	if current_animation != new_animation:
		current_animation= new_animation
		$movement.play(current_animation)

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
		transition_to(DOOR_OUT)
	if state == DOOR_OUT and animation_finished==4:
		transition_to(IDLE)
	if state == DOOR_OUT and animation_finished==4 and running:
		transition_to(RUN)

#estados danio
	if state in [IDLE, RUN, JUMP, FALL] and hurt:
		transition_to(HIT)
	if state == HIT and is_on_floor() and animation_finished==2:
		transition_to(IDLE)
	if state==HIT and !is_on_floor() and animation_finished==2:
		transition_to(FALL)
	if state in [HIT,IDLE,JUMP,FALL] and vidas<=0 and animation_finished==2:
		transition_to(DEAD)

#WILLY ESTO HICE PARA PROBAR EL LLAMADO DEL CERDITO AL HACERLE DAÑO :V
func _on_ataque_body_entered(body):
	
	body.hacerDanio(global_position.x)

func cambiar_label():
	$Camera2D/Label.text = ("VIDAS x"+str(vidas))

func accion():
	print("accion...")

func movimiento_Personaje(estado):
	moverse=estado

func cambiar_estado(estado):
	input_state=estado

func mover_a(posicion):
	motion= move_and_slide(posicion,UP)

func retroceso():
	if $movement.flip_h==true:
		mover_a(Vector2(70,0))
	else:
		mover_a(Vector2(-70,0))

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
	vidas=n_vidas
	mover_a(posicion)
	
func mover_cuerpo(posicion):
	position=posicion

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
			emit_signal("attack")
			if is_on_floor():
				movimiento_Personaje(false)
			print("ataco....")
		
		#Para la accion
		if Input.is_action_just_pressed("ui_page_down") and Jugador.can_action:
			#transition_to(DOOR_IN)
			action_released=true
			cambiar_estado(false)
			movimiento(false)
			movimiento_Personaje(false)
			#Jugador.can_action=true
			#print("HIPP")
			#accion()
			#mover_cuerpo(Vector2(773,99))


func _on_tiempo_de_ataque_timeout():
	can_attack=true
