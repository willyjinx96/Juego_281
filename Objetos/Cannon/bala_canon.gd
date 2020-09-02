extends RigidBody2D

var dst_position=Vector2(970,512)
var delta = 3

func _ready():
	movimiento(dst_position, delta)

func _physics_process(delta):
	if ceil(position.x) == ceil(dst_position.x):
		print(position)
	
func movimiento(dst_position, delta):
	var force =1000
	var vx =dst_position.x/delta
	var h = abs(position.y-dst_position.y)
	var vy=(dst_position.y -h +(1/2)*gravity_scale*delta*delta)/delta
	if dst_position.x < position.x:
		vx=vx*-1
		force = force*-1
	if dst_position.y == position.y:
		vy=0
	linear_velocity=Vector2(vx,-vy)
	print(linear_velocity)
	#applied_force=Vector2(force,0)
	pass
