extends KinematicBody2D

const up = Vector2(0, -1)
const grav = 100
const maxFallSpeed = 800
const maxSpeed = 500#80
const jumpForce = 1500#300 
const accel = 50#10 

var motion = Vector2()
var dirRight = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(_delta):
	motion.y += grav 
	if motion.y > maxFallSpeed:
		motion.y = maxFallSpeed
	
	if dirRight == true:
		$Sprite.scale.x = 1
	else:
		$Sprite.scale.x = -1
	
	motion.x = clamp(motion.x, -maxSpeed, maxSpeed)
	
	if Input.is_action_pressed("right"):
		motion.x += accel
		dirRight = true
		if is_on_floor():
			$AnimationPlayer.play("run")
	elif Input.is_action_pressed("left"):
		motion.x += -accel
		dirRight = false 
		if is_on_floor():
			$AnimationPlayer.play("run")
	else:
		motion.x = lerp(motion.x, 0, 0.2)
		if is_on_floor():
			$AnimationPlayer.play("idle")
		
	if is_on_floor():
		if Input.is_action_pressed("jump"):
			motion.y = -jumpForce
			
	if !is_on_floor():
		if motion.y < 0:
			$AnimationPlayer.play("jump")
		elif motion.y > 0:
			$AnimationPlayer.play("fall") 
			
	motion = move_and_slide(motion, up)
	
func _on_Button_Pressed():
	Global.camera.shake(1,5)
