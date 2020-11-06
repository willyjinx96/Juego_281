extends Node2D


func _ready():
	Music.change_music(3)
	pass
		
#func _on_pelea_body_entered(body):
#	if body.name =="Rey_p1":
#		cerrar()
#	pass # Replace with function body.
#
#func cerrar():
#	$Escenario/ambientes/castillo.set_cell(144,-38,0,false,false,false,Vector2(9,3))
#	$Escenario/ambientes/castillo.set_cell(144,-37,0,false,false,false,Vector2(4,1))
#	$Escenario/ambientes/castillo.set_cell(144,-36,0,false,false,false,Vector2(4,1))
#	$Escenario/ambientes/castillo.set_cell(144,-35,0,false,false,false,Vector2(4,1))
#	$Escenario/ambientes/castillo.set_cell(144,-34,0,false,false,false,Vector2(10,0))
#	pass
