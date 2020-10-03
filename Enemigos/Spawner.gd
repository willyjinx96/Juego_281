extends Position2D

onready var pig_scene = preload("res://Enemigos/cerdo/CerdoEnemigo.tscn")
export var min_time =  8
export var max_time =  20
	
func _on_Timer_timeout():
	$AnimatedSprite.play("puff")
	$Timer.wait_time = rand_range(min_time,max_time)
	pass # Replace with function body.
	
func aparecer_cerdo():
	var cerdonio = pig_scene.instance()
	get_parent().add_child(cerdonio)
	if Jugador.vidas <= 2:
		cerdonio.items(true,true,false)
	else :
		cerdonio.items(false,true,false)
	cerdonio.global_position=global_position


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "puff":
		$AnimatedSprite.play("espera")
	pass # Replace with function body.


func _on_AnimatedSprite_frame_changed():
	if $AnimatedSprite.frame == 6:
		aparecer_cerdo()
	pass # Replace with function body.
