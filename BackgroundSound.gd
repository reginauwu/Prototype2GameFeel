extends AudioStreamPlayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var bgm = $BackgroundSound

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Global.sound_toggle):
		bgm.play()
	else:
		bgm.stop()
