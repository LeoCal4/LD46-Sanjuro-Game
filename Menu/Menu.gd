extends Node2D

var angle = 0
var center = 0
var radius = 5
var rotation_speed = 3

func _on_Button_pressed():
	SceneLoader.load_scene("res://Scene1.tscn")

func _ready():
	center = $Logo.position

func _physics_process(delta):
	angle += rotation_speed * delta
	$Logo.position = center + Vector2(sin(angle/2), cos(angle)) * radius