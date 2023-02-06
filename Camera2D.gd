extends Camera2D

var shake_amount = 0
var default_offset = offset
onready var tween = $Tween
onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	Global.camera = self
	randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	offset = Vector2(rand_range(-1,1) * shake_amount, rand_range(-1,1) * shake_amount)
	
func shake(time, amount):
	timer.wait_time = time
	shake_amount = amount
	set_process(true)
	timer.start()
	timer.connect("timeout",self,"_on_Timer_timeout")

func _on_Timer_timeout():
	set_process(false)
	tween.interpolate_property(self, "offset", offset, default_offset, 0.1, 6, 2)
	tween.start()
