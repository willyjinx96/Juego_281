extends RigidBody2D

var current_position
var dst_position = Vector2(0,0)
var delta =2

func _ready():
	current_position = position
	pass # Replace with function body.

func _physics_process(delta):
	current_position = position
	pass
	
func lanzamiento(delta, dst_position):
	var vx=dst_position.x/delta
	var h=current_position.y-dst_position.y
	var vy = (dst_position.y -h +(1/2)*gravity_scale*delta*delta)/delta
	if current_position.x>dst_position.x:
		vx=vx*-1
		
	linear_velocity=Vector2(vx*2.1,-vy*2.1)
	print(linear_velocity,current_position)
	pass

func cambiar_destino():
	pass


func _on_Area2D_body_entered(body):
	if body.is_in_group("objetivo"):
		lanzamiento(3,body.position)
		print("hola ",body.position)
		pass # Replace with function body.
