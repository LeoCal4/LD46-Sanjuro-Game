extends Node2D

const MAX_HEALTH = 100

onready var label = $Label
onready var sprite = $Sprite
onready var soul_particles = $SoulParticles

var center = 0
var rotation_speed = 3
var radius = 5
var angle = 0
var current_frame = 1
var hp = MAX_HEALTH / 2 setget set_hp
var time_passed = 0

func _ready():
	center = position

func _physics_process(delta):
	time_passed += delta
	if time_passed >= 1:
		set_hp(-time_passed)
		time_passed = 0
	angle += rotation_speed * delta
	position = center + Vector2(sin(angle/2), cos(angle) * radius)

func set_hp(amount):
	hp = clamp(hp + amount, 0, MAX_HEALTH)
	label.text = str(int(hp))
	if hp >= 90: 
		current_frame = 0
	elif hp >= 50:
		current_frame = 1
	elif hp >= 25: 
		current_frame = 2
	else:
		current_frame = 3
	sprite.frame = current_frame

func receive_soul():
	sprite.frame = 4
	soul_particles.emitting = true
	yield(get_tree().create_timer(0.3), "timeout")
	set_hp(5)
	soul_particles.emitting = false
	sprite.frame = current_frame