extends RigidBody2D

var images = ["res://Assets/Sprites/08-Box/Box Pieces 1.png",
"res://Assets/Sprites/08-Box/Box Pieces 2.png",
"res://Assets/Sprites/08-Box/Box Pieces 3.png",
"res://Assets/Sprites/08-Box/Box Pieces 4.png"]

func _ready():
	randomize()
	pass

func crear(n):
	$Sprite.texture = load(images[n])
	var d= int (rand_range(0,10))
	linear_velocity.x = pow(-1,d)*linear_velocity.x
