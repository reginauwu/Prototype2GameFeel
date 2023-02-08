extends KinematicBody2D

const up = Vector2(0, -1)
const grav = 50
const maxFallSpeed = 800
const jumpForce = 1500#300 
var maxSpeed = 500#80
var accel = 50#10 
var jumped = false
var finishLanding = true

var motion = Vector2()
var dirRight = true

var mus_pos = 0

onready var sfxWalk = $PlayerWalkSound
onready var sfxJump = $PlayerJumpSound
onready var sfxLand = $PlayerLandSound
onready var sfxHit = $PlayerHitSound


#var sprinting = false
#var doubleTapR = false
#var doubleTapL = false

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
	
	if(Global.particle_toggle):
		$Particles.visible = true
	else:
		$Particles.visible = false
	
	if Input.is_action_pressed("right"):
		motion.x += accel
		dirRight = true
		if is_on_floor() and !jumped and finishLanding:
			if(Global.animation_toggle):
				$Sprite.visible = false
				$Sprite2.visible = true
				$AnimationPlayer.play("run")
			if(Global.sound_toggle) and !sfxWalk.is_playing():
				sfxWalk.play()
			#$CPUParticles2D.visible = true
#		if doubleTapR == true:
#			sprinting = true
#			sprintTime()
	elif Input.is_action_pressed("left"):
		motion.x += -accel
		dirRight = false 
		if is_on_floor() and !jumped and finishLanding:
			if(Global.animation_toggle):
				$Sprite.visible = false
				$Sprite2.visible = true
				$AnimationPlayer.play("run")
			if(Global.sound_toggle) and !sfxWalk.is_playing():
				sfxWalk.play()
			#$CPUParticles2D.visible = true
#		if doubleTapL == true:
#			sprinting = true
#			sprintTime()
	else:
		if(Global.animation_toggle):
			$Sprite.visible = true
			$Sprite2.visible = false
		#$CPUParticles2D.visible = false
		motion.x = lerp(motion.x, 0, 0.2)
		if is_on_floor() and !jumped and finishLanding:
			sfxWalk.stop()
			if(Global.animation_toggle):
				$AnimationPlayer.play("idle")
			
#	if Input.is_action_just_released("right") and !jumped:
#		if sprinting == true:
#			sprinting = false
#		doubleTapR = true
#		$Timer.start()
#	elif Input.is_action_just_released("left") and !jumped:
#		if sprinting == true:
#			sprinting = false
#		doubleTapL = true
#		$Timer.start()


#	if sprinting == true:
#		accel = 500
#		maxSpeed = 2000
#	else: 
#		accel = 50
#		maxSpeed = 500
		

		
	if is_on_floor():
		if jumped:
			jumped = false
			if(Global.animation_toggle):
				$Sprite.visible = true
				$Sprite2.visible = false
				$AnimationPlayer.play("land")
			if(Global.particle_toggle):
				$SpriteLandEffect.visible = true
				$AnimationPlayer2.play("landEffect")
			if (Global.sound_toggle) and !sfxLand.is_playing():
				sfxLand.play()
			yield(get_tree().create_timer($AnimationPlayer.get_animation("land").length), "timeout")
			print("landed")
			$SpriteLandEffect.visible = false
			finishLanding = true
			#jumped = false
			#motion.x = 0
		elif Input.is_action_just_pressed("jump") and finishLanding:
			finishLanding = false
			print("jumped")
			if (Global.sound_toggle):
				sfxWalk.stop()
				sfxJump.play()
			if(Global.animation_toggle):
				$Sprite.visible = true
				$Sprite2.visible = false
			jumped = true
			motion.y = -jumpForce
			#jumped = true
			
	if !is_on_floor():
		if motion.y < 0:
			if(Global.animation_toggle):
				$AnimationPlayer.play("jump")
		elif motion.y > 0:
			if(Global.animation_toggle):
				$AnimationPlayer.play("fall") 
			
	motion = move_and_slide(motion, up)
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if(collision.collider.name == "Enemy"):
			if (Global.sound_toggle) and !sfxHit.is_playing():
				sfxHit.play()
			if (Global.shake_button_toggle):
				Global.camera.shake(0.25,5)
			if (dirRight):
				motion.x -= 5000
			else:
				motion.x += 500

	
#func sprintTime():
#	yield(get_tree().create_timer(0.1), "timeout")
#	sprinting = false

#func _on_Timer_timeout():
#	doubleTapL = false
#	doubleTapR = false

# Shake Toggle
func _on_CheckButton_toggled(button_pressed):
	if(button_pressed):
		Global.shake_button_toggle = true
	else:
		Global.shake_button_toggle = false
		
# Animation Toggle
func _on_CheckButton2_toggled(button_pressed):
	if(button_pressed):
		Global.animation_toggle = true
	else:
		Global.animation_toggle = false
		
# Particle Toggle
func _on_CheckButton3_toggled(button_pressed):
	if(button_pressed):
		Global.particle_toggle = true
	else:
		Global.particle_toggle = false

# Sound Toggle
func _on_CheckButton4_toggled(button_pressed):
	if(button_pressed):
		Global.sound_toggle = true
		GlobalAudioStreamPlayer.play(mus_pos)
	else:
		Global.sound_toggle = false
		mus_pos = GlobalAudioStreamPlayer.get_playback_position()
		GlobalAudioStreamPlayer.stop()
