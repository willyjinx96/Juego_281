extends Position2D

onready var pig_scene = preload("res://Enemigos/cerdo/CerdoEnemigo.tscn")
export var min_time =  8
export var max_time =  20
export var cantidad = 0
export var infinito = true
var cont = 0
export var generar = true
var activo =false

func _on_Timer_timeout():
	if activo and generar:
		$AnimatedSprite.play("puff")
		$Timer.wait_time = rand_range(min_time,max_time)
	elif cantidad ==-1:
		cont =0
	else:
		$Timer.one_shot = true
		$Timer.stop()
	pass # Replace with function body.
	
func aparecer_cerdo():
	cont +=1
	if not infinito:
		if cont<=cantidad:
			var cerdonio = pig_scene.instance()
			get_parent().add_child(cerdonio)
			if randi()%4==0:
				cerdonio.items(true,true,false)
			else :
				var rand_bool = randi()%2==0
				cerdonio.items(false,rand_bool,false)
			if cont == cantidad:
				cerdonio.items(true,true,false)
				#print(">>>",rand_bool)
			cerdonio.global_position=global_position
		else:
			generar = false
	else:
		var cerdonio = pig_scene.instance()
		get_parent().add_child(cerdonio)
		if randi()%4==0:
			cerdonio.items(true,true,false)
		else :
			var rand_bool = randi()%2==0
			cerdonio.items(false,rand_bool,false)
		#print(">>>",rand_bool)
		cerdonio.global_position=global_position



func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "puff":
		$AnimatedSprite.play("espera")
	pass # Replace with function body.


func _on_AnimatedSprite_frame_changed():
	if $AnimatedSprite.frame == 6:
		aparecer_cerdo()
	pass # Replace with function body.


func _on_VisibilityNotifier2D_screen_entered():
	#print ("entro..")
	activo=true
	$Timer.one_shot =false
	$Timer.start()
	pass # Replace with function body.


func _on_VisibilityNotifier2D_screen_exited():
	#print ("salio..")
	activo=false
	$Timer.one_shot =true
	$Timer.stop()
	pass # Replace with function body.
	
func terminar(b):
	generar = b
