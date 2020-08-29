extends KinematicBody2D

const UP = Vector2(0,-1)
const GRAVITY = 20
const ACCELERATION = 50
const MAX_SPEED = 200
const JUMP_HEIGHT = -400

var motion = Vector2()

func _physics_process(delta):
	motion.y += GRAVITY
	
	var friction =false
	
	if Input.is_action_pressed("ui_right"):
		motion.x =min(motion.x+ACCELERATION, MAX_SPEED)
		$CollisionShape2D.position.x=-16.689
		
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.play("run")
	elif Input.is_action_pressed("ui_left"):
		$CollisionShape2D.position.x=3
		motion.x =max(motion.x - ACCELERATION, -MAX_SPEED)
		$AnimatedSprite.flip_h=true
		$AnimatedSprite.play("run")
	else:
		$AnimatedSprite.play("idle")
		friction = true
		
	if is_on_floor():
		#$AnimatedSprite.play("ground")
		if Input.is_action_pressed("ui_up"):
			motion.y = JUMP_HEIGHT
		if friction == true:
			motion.x = lerp(motion.x, 0 , 0.15)
	else:
		if motion.y < 0:
			$AnimatedSprite.play("jump")
		else:
			$AnimatedSprite.play("fall")
		if friction == true:
			motion.x = lerp(motion.x, 0 , 0.05)
	
	#print(motion)
	motion = move_and_slide(motion, UP)
