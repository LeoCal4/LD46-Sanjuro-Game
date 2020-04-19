extends Area2D

var center = 0
var rotation_speed = 1
var radius = 3
var angle = 0
var time = 0

var is_getting_picked = false

func _ready():
	center = position

func _physics_process(delta):
	angle += rotation_speed * delta
	position = center + Vector2(sin(angle/2), cos(angle)) * radius
	handle_time(delta)

func handle_time(delta):
	time += delta 
	if time >= 10:
		queue_free()

func get_picked_up():
	is_getting_picked = true
	if Globals.sound:
		$PickupSound.play()
		visible = false
		$CollisionShape2D.disabled = true
		while ($PickupSound.is_playing()):
			yield(get_tree(), 'idle_frame')
	queue_free()