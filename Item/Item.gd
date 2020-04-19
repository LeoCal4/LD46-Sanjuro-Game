extends Area2D

var center = 0
var rotation_speed = 1
var radius = 3
var angle = 0
var time = 0

func _ready():
	center = position

func _physics_process(delta):
	angle += rotation_speed * delta
	position = center + Vector2(sin(angle/2), cos(angle)) * radius
	time += delta 
	if time >= 10:
		queue_free()