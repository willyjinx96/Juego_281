extends Position2D
var balas = preload("res://Objetos/Cannon/bala_canon.tscn")

func _on_cannon_shoot():
	var shooting_bullet = balas.instance()
	get_parent().add_child(shooting_bullet)
	shooting_bullet.global_position=global_position
