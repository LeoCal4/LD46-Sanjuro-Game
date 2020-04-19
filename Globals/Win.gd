extends Node2D

var center = 0
var rotation_speed = 3
var radius = 10
var angle = 0


func _ready():
	center = position


func _physics_process(delta):
	angle += rotation_speed * delta
	position = center + Vector2(sin(angle), cos(angle)) * radius