extends RigidBody2D

signal shoot
var dst_position

func _on_area_danio_body_entered(body):
	if body.is_in_group("jugador"):
		emit_signal("shoot")
		dst_position=body.position
		$AnimatedSprite.play("shoot")
	pass # Replace with function body.


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation=="shoot":
		$AnimatedSprite.play("idle")
