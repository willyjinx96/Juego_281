extends KinematicBody2D

var accionSwIzquierda=true
var esEnemigoDetectado=false
var gravedad=200
var velocidad_movimiento=50
var moverX=Vector2(-1,0)

enum {CAMINAR,ATACAR,PARADO}
var estado
var animacion_Actual
var nueva_animacion

func cambiarTransicion_a(nuevo_estado):
	estado=nuevo_estado
	match estado:
		PARADO:
			nueva_animacion="parado"
		CAMINAR:
			nueva_animacion="caminar"
		ATACAR:
			nueva_animacion="atacar"

# Called when the node enters the scene tree for the first time.
func _ready():
	cambiarTransicion_a(CAMINAR)
	

func _physics_process(delta):
	#procesos constantes  -----------------------
	if animacion_Actual!=nueva_animacion:
		animacion_Actual=nueva_animacion
		$AnimatedSprite.play(animacion_Actual)
	var posicion=Vector2()
	posicion+=Vector2(0,1)
	posicion.y=posicion.y*gravedad
	#--------------------------------------------
	#----------procesos cambiantes---------------
	
	
	if $detectarFrente.get_collider()!=null:
		print($detectarFrente.get_collider().get("name"))
		if $detectarFrente.get_collider().get("name")=="castillo":
			moverX*=-1
			if moverX.x>0:
				$detectarFrente.rotation_degrees=270
				$AnimatedSprite.flip_h=true
			elif moverX.x<0:
				$detectarFrente.rotation_degrees=90
				$AnimatedSprite.flip_h=false
	
	posicion+=moverX
	
	posicion.x=posicion.x*velocidad_movimiento
	move_and_slide(posicion,Vector2(0,-1))



