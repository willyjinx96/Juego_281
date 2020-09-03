extends KinematicBody2D

var accionSwIzquierda=true
var esEnemigoDetectado=false
var gravedad=200
var velocidad_movimiento=50
var moverX=Vector2(-1,0)
var saveMoveX
var estaAtacando=false
var nombreJugador="Rey_p1"

enum {CAMINAR,ATACAR,PARADO,CAIDA,DANIO}
var estado
var estadoAux
var animacion_Actual
var nueva_animacion

signal darGolpe

func cambiarTransicion_a(nuevo_estado):
	estado=nuevo_estado
	match estado:
		PARADO:
			nueva_animacion="parado"
			guardarMovimientoEnX()
		CAMINAR:
			nueva_animacion="caminar"
			moverX=saveMoveX
		ATACAR:
			nueva_animacion="atacar"
			guardarMovimientoEnX()
		CAIDA:
			nueva_animacion="caida"
			guardarMovimientoEnX()
		DANIO:
			nueva_animacion="danio"
			guardarMovimientoEnX()


func guardarMovimientoEnX():
	if moverX!=Vector2(0,0) :
		saveMoveX=moverX
		moverX=Vector2(0,0)
		

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	saveMoveX=moverX
	cambiarTransicion_a(CAMINAR)
	$caminar.start(rand_range(8,14))
	
	




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
	
	var deteccionFrente=$detectarFrente.get_collider()
	var deteccionPiso=$detectarFrente/detectarPiso.get_collider()
	var esEnPiso=is_on_floor()
	
	if deteccionFrente!=null and esEnPiso and estado!=DANIO:
		#cambiarTransicion_a(CAMINAR)
		var nombreObjetoFrente=deteccionFrente.get("name")
		#print(nombreObjetoFrente)
		if nombreObjetoFrente=="castillo" and estado!=DANIO:
			cambiarDireccionMovimiento()
		elif nombreObjetoFrente==nombreJugador and estado!=ATACAR and animacion_Actual!="atacar" and !estaAtacando:
			cambiarTransicion_a(ATACAR)
			estaAtacando=true
			$duracionAtaque.start(1)
			$caminar.stop()
			$duracionParado.stop()
	elif deteccionPiso==null and esEnPiso:
		cambiarDireccionMovimiento()
	elif !esEnPiso and moverX!=saveMoveX and estado!=DANIO:
		cambiarTransicion_a(CAIDA)
	
	
	if estado==ATACAR:
		golpeandoJugador()
	
	posicion+=moverX
	
	posicion.x=posicion.x*velocidad_movimiento
	
	move_and_slide(posicion,Vector2(0,-1))



func hacerDanio(var ejeX)->void:
	if estado!=DANIO:
		$caminar.stop()
		$duracionParado.stop()
		$duracionAtaque.stop()
		estaAtacando=false
		cambiarTransicion_a(DANIO)
		$hitbox/CollisionShape2D.set_deferred("disabled",true)
		var direccion=global_position.x-ejeX
		var sentido=direccion/abs(direccion)
		moverX=Vector2(sentido,0)
		saveMoveX=-1*moverX
		
	
	

func cambiarDireccionMovimiento():
	moverX*=-1
	ajustarFrente()

func ajustarFrente():
	if moverX.x>0 or (saveMoveX.x>0 and moverX.x==0):
		$detectarFrente.rotation_degrees=270
		$detectarFrente/detectarPiso.rotation_degrees=90
		$AnimatedSprite.flip_h=true
		$hitbox.position.x=11
	elif moverX.x<0 or (saveMoveX.x<0 and moverX.x==0):
		$detectarFrente.rotation_degrees=90
		$detectarFrente/detectarPiso.rotation_degrees=-90
		$AnimatedSprite.flip_h=false
		$hitbox.position.x=-9
	

func launchRay(var vect):
	var estadoEspacial=get_world_2d().direct_space_state
	
	var resultadoRayo=estadoEspacial.intersect_ray(global_position,vect,[self])
	
	#if str(resultadoRayo)


##BORRAR ESTO DESPUES si no se encuentra uso al timer de duracion Ataque
func _on_duracionAtaque_timeout():
	pass


func _on_caminar_timeout():
	cambiarTransicion_a(PARADO)
	$caminar.stop()
	$duracionParado.start(rand_range(5,8))


func _on_duracionParado_timeout():
	cambiarTransicion_a(CAMINAR)
	$duracionParado.stop()
	$caminar.start(rand_range(8,14))


func golpeandoJugador():
	var numFrame=$AnimatedSprite.frame
	var intervaloAtaque=(numFrame>=2 and numFrame<=3) and estaAtacando and animacion_Actual=="atacar"
	
	if intervaloAtaque:
		print("atacado")
		
		numGolpes+=1
		print(numGolpes)
		estaAtacando=false
		$hitbox/CollisionShape2D.set_deferred("disabled",false)
		
		


var numGolpes=0




func _on_hitbox_body_exited(body):
	#estaAtacando=false
	$hitbox/CollisionShape2D.set_deferred("disabled",true)
	emit_signal("darGolpe")


func _on_hitbox_body_entered(body):
	print(body.name)
	body.damage()


func _on_AnimatedSprite_animation_finished():
	
	match estado:
		ATACAR:
			cambiarTransicion_a(PARADO)
			estaAtacando=false
			$hitbox/CollisionShape2D.set_deferred("disabled",true)
			$duracionAtaque.stop()
			$duracionParado.start(rand_range(3,5))
		DANIO:
			cambiarTransicion_a(CAMINAR)
			$caminar.start(rand_range(8,14))
			ajustarFrente()
