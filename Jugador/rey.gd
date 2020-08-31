extends KinematicBody2D

const UP = Vector2(0,-1)
const GRAVITY = 200
const ACCELERATION = 50
const MAX_SPEED = 200
const JUMP_HEIGHT = -400


var motion = Vector2() 

func _physics_process(delta):
	print(position)
	$ataque/CollisionShape2D.disabled=true
	motion.y += GRAVITY*delta
	
	var friction =false
	
	var right = Input.is_action_pressed("ui_right")
	var left = Input.is_action_pressed("ui_left")
	var attack = Input.is_key_pressed(KEY_C)
		
	if right and not attack:
		motion.x =min(motion.x+ACCELERATION, MAX_SPEED)
		$CollisionShape2D.position.x=0
		$AnimatedSprite.position.x=8.689
		$ataque/CollisionShape2D.position.x =0
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.play("run")
	elif left and not attack:
		$CollisionShape2D.position.x=0
		$ataque/CollisionShape2D.position.x =-67
		$AnimatedSprite.position.x=-8.689
		motion.x =max(motion.x - ACCELERATION, -MAX_SPEED)
		$AnimatedSprite.flip_h=true
		$AnimatedSprite.play("run")
	elif attack and (right or left) and is_on_floor():
		motion.x=0
		ataque()
	elif attack:
		ataque()
	else:
		$AnimatedSprite.play("idle")
		friction = true
		
	if is_on_floor():
		#$AnimatedSprite.play("ground")
		if Input.is_action_pressed("ui_up"):
			motion.y =JUMP_HEIGHT
		if friction == true:
			motion.x = lerp(motion.x, 0 , -0.20)
	else:
		if motion.y < 0 and not attack:
			$AnimatedSprite.play("jump")
		elif motion.y < 0 and attack:
			ataque()
		elif motion.y >=0 and not attack:
			$AnimatedSprite.play("fall")
		elif motion.y >=0 and attack:
			ataque()

	
		if friction == true:
			motion.x = lerp(motion.x, 0 , 0.05)
	if Input.is_action_just_released("ui_up") and motion.y <0 and is_on_floor():
		motion.y =-200
	
	motion = move_and_slide(motion, UP)

func ataque():
	$AnimatedSprite.play("attack")
	$ataque/CollisionShape2D.disabled=false
	
func _on_AnimatedSprite_animation_finished():
	if name == "attack":
		$AnimatedSprite.play("idle")
		$ataque/CollisionShape2D.disabled = true


func _on_danio_body_entered(body):
	if body.name=="rey":
		print("CHOCO.................")
		$AnimatedSprite.play("hit")
		pass
	pass # Replace with function body.
var running = (Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left"))
var not_running = (Input.is_action_just_released("ui_right") or Input.is_action_just_released("ui_left"))
