extends KinematicBody2D

#maquina de estados (Animacion)
enum {IDLE, RUN, JUMP, FALL, GROUND, ATTACK, HIT, DEAD, DOOR_IN, DOOR_OUT}
var state
var current_animation
var new_animation

#fisica de movimientos
const UP = Vector2(0,-1)
const GRAVITY = 15
var ACCELERATION = 50
var MAX_SPEED = 200
const MAX_JUMP_HEIGHT = -400
const MIN_JUMP_HEIGHT = -200
var motion=Vector2()

#variables para accion
signal attack #KEY_C
var attacking =false
signal action#KEY_X
var action_released =false

var animation_finished=0

#variables danio
signal hit
var hurt =false

#variables de vida

export var vidas = 6000
var dead =false
var moverse

func _ready():
	movimiento_Personaje(true)
	transition_to(IDLE)
	
func _physics_process(delta):
	cambiar_label()
	estados()
	movimiento()
	if vidas ==0:
		movimiento_Personaje(false)
		
	animation_finished=0
	if moverse:
		motion = move_and_slide(motion,UP)


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
		attacking=false
		MAX_SPEED=200
	if $movement.animation == "door_in":
		animation_finished = 3
		action_released=false
	if $movement.animation == "door_out":
		animation_finished=4
	if $movement.animation=="dead":
		pausar()

func _on_KinematicBody2D_attack():
	$ataque/CollisionShape2D.disabled=false
	attacking=true

func _on_danio_area_entered(area):
	if area.is_in_group("enemigos"):
		damage()

func pausar():
	get_tree().paused=true

func _on_danio_body_entered(body):
	if body.is_in_group("enemigos"):
		damage()

func damage():
	vidas -=1
	hurt =true
	MAX_SPEED=-150
	motion = Vector2.ZERO

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
		motion.x=0
	if state in [JUMP, FALL] and attacking:
		transition_to(ATTACK)
	if state == ATTACK and animation_finished==1 and is_on_floor():
		transition_to(IDLE)
	if state == ATTACK and animation_finished==1 and motion.y<0:
		transition_to(JUMP)
	if state == ATTACK and animation_finished==1 and motion.y>=0:
		transition_to(FALL)
	
#estados accion
#	if state in [IDLE, RUN] and action_released:
#		transition_to(DOOR_IN)
#	if state == DOOR_IN and animation_finished==3:
#		transition_to(DOOR_OUT)
#	if state == DOOR_OUT and animation_finished==4:
#		transition_to(IDLE)
#	if state == DOOR_OUT and animation_finished==4 and running:
#		transition_to(RUN)

#estados danio
	if state in [IDLE, RUN, JUMP, FALL] and hurt:
		transition_to(HIT)
	if state == HIT and is_on_floor() and animation_finished==2:
		transition_to(IDLE)
		motion.x=0
	if state==HIT and !is_on_floor() and animation_finished==2:
		transition_to(FALL)
		motion.y=0
	if state in [HIT,IDLE,JUMP,FALL] and vidas==0 and animation_finished==2:
		transition_to(DEAD)

#WILLY ESTO HICE PARA PROBAR EL LLAMADO DEL CERDITO AL HACERLE DAÑO :V
func _on_ataque_body_entered(body):
	print(body.name)
	body.hacerDanio(global_position.x)

func cambiar_label():
	$Camera2D/Label.text = ("VIDAS x"+str(vidas))

func accion():
	print("accion...")

func movimiento_Personaje(estado):
	moverse=estado

func movimiento():
	motion.y += GRAVITY
	var friction =false
	#Para movimiento derecha e izquierda
	if Input.is_action_pressed("ui_right"):
		$movement.flip_h=false
		$movement.position.x=0
		$ataque/CollisionShape2D.position.x=10.709
		motion.x =min(motion.x+ACCELERATION, MAX_SPEED)
	elif Input.is_action_pressed("ui_left"):
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
		if friction == true:
			motion.x = lerp(motion.x, 0 , 0.20)
	elif friction == true:
			motion.x = lerp(motion.x, 0 , 0.05)
	if Input.is_action_just_released("ui_up") and motion.y <0:
		motion.y =MIN_JUMP_HEIGHT
	
	#Para ataque
	if Input.is_action_just_pressed("ui_page_up"):
		emit_signal("attack")
		if is_on_floor():
			movimiento_Personaje(false)
		print("ataco....")
	
	#Para la accion
	if Input.is_action_just_pressed("ui_page_down"):
		connect("action",self, "accion")
