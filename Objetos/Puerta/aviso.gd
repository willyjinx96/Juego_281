extends Node2D


func _ready():
	visible =false
	global_scale=Vector2(0.2,0.2)
	pass

func iniciar():
	$AnimationPlayer.play("entrada")
