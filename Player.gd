extends KinematicBody2D

const up = Vector2(0, -1)
const grav = 50
const maxFallSpeed = 800
const jumpForce = 1500#300 
var maxSpeed = 500#80
var accel = 50#10 
var jumped = false

var motion = Vector2()
var dirRight = true

var sprinting = false
var doubleTapR = false
var doubleTapL = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(_delta):
	motion.y += grav 
	if motion.y > maxFallSpeed:
		motion.y = maxFallSpeed
	
	if dirRight == true:
		$Sprite.scale.x = 1
		$Sprite2.scale.x = 1
	else:
		$Sprite.scale.x = -1
		$Sprite2.scale.x = -1
	
	motion.x = clamp(motion.x, -maxSpeed, maxSpeed)

	
	if Input.is_action_pressed("right"):
		motion.x += accel
		dirRight = true
		if is_on_floor() and !jumped:
			$Sprite.visible = false
			$Sprite2.visible = true
			$AnimationPlayer.play("run")
			#$CPUParticles2D.visible = true
		if doubleTapR == true:
			sprinting = true
			sprintTime()
	elif Input.is_action_pressed("left"):
		motion.x += -accel
		dirRight = false 
		if is_on_floor() and !jumped:
			$Sprite.visible = false
			$Sprite2.visible = true
			$AnimationPlayer.play("run")
			#$CPUParticles2D.visible = true
		if doubleTapL == true:
			sprinting = true
			sprintTime()
	else:
		$Sprite.visible = true
		$Sprite2.visible = false
		#$CPUParticles2D.visible = false
		motion.x = lerp(motion.x, 0, 0.2)
		if is_on_floor() and !jumped:
			$AnimationPlayer.play("idle")
			
	if Input.is_action_just_released("right") and !jumped:
		if sprinting == true:
			sprinting = false
		doubleTapR = true
		$Timer.start()
	elif Input.is_action_just_released("left") and !jumped:
		if sprinting == true:
			sprinting = false
		doubleTapL = true
		$Timer.start()


	if sprinting == true:
		accel = 500
		maxSpeed = 2000
	else: 
		accel = 50
		maxSpeed = 500
		
		
	if is_on_floor():
		if jumped:
			$Sprite.visible = true
			$Sprite2.visible = false
			$AnimationPlayer.play("land")
			$SpriteLandEffect.visible = true
			$AnimationPlayer2.play("landEffect")
			yield(get_tree().create_timer(0.4), "timeout")
			$SpriteLandEffect.visible = false
			jumped = false
			motion.x = 0
		elif Input.is_action_just_pressed("jump"):
			$Sprite.visible = true
			$Sprite2.visible = false
			jumped = true
			motion.y = -jumpForce
			#jumped = true
			
	if !is_on_floor():
		if motion.y < 0:
			$AnimationPlayer.play("jump")
		elif motion.y > 0:
			$AnimationPlayer.play("fall") 
			
	motion = move_and_slide(motion, up)
	
func sprintTime():
	yield(get_tree().create_timer(0.1), "timeout")
	sprinting = false

func _on_Timer_timeout():
	doubleTapL = false
	doubleTapR = false

func _on_Button_pressed():
	if(Global.shake_button_toggle):
		Global.camera.shake(1,4)

# Shake Toggle
func _on_CheckButton_toggled(button_pressed):
	if(button_pressed):
		Global.shake_button_toggle = true
	else:
		Global.shake_button_toggle = false
