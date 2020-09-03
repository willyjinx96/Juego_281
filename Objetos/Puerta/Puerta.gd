extends Area2D

var state
var current_animation
var new_animation

enum {IDLE, OPENNING, CLOSSING}

func _ready():
	transtion_to(IDLE)

func transtion_to(new_state):
	state=new_state
	
	match state:
		IDLE:
			new_animation ="idle"
			pass
		OPENNING:
			new_animation="opennig"
			pass
		CLOSSING:
			new_animation="clossing"
			pass

func estado():
	if current_animation != new_animation:
		current_animation= new_animation
		$estados.play(current_animation)


func _on_door_body_entered(body):
	print("entro")
	pass # Replace with function body.
