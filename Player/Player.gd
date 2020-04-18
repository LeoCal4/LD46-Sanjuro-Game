extends KinematicBody2D

var MOVE_SPEED = 3000
const MAX_SPEED = MOVE_SPEED * 12
var SHOOT_DELAY = 0.3
const FRICTION = 10 
const MAX_HEALTH = 100
var DAMAGE = 20

onready var bullet_start_position = $BulletStartPosition
const bullet_scene = preload("res://Player/Bullet/Bullet.tscn")

var health
var move_dir
var velocity
var acceleration
var shoot_delay_timer
var can_shoot
var can_sacrifice_souls
var souls = 10


func _ready():
	health = MAX_HEALTH
	move_dir = Vector2(0, 0)
	velocity = Vector2(0, 0)
	acceleration = Vector2.ZERO
	shoot_delay_timer = get_tree().create_timer(SHOOT_DELAY)
	can_shoot = true
	yield(get_tree(), 'idle_frame')
	get_tree().call_group('enemies', 'set_player', self)

func _physics_process(delta):
	_handle_movement_input()
	_handle_shooting()
	_apply_movement(delta)
	_apply_friction(delta)
	if Input.is_action_just_pressed('action'):
		if can_sacrifice_souls:
			sacrifice_souls()
	#look_at(get_global_mouse_position())

func _handle_movement_input():
	move_dir = Vector2.ZERO
	var move_dir_y = int(Input.is_action_pressed('down')) - int(Input.is_action_pressed('up'))
	var move_dir_x = int(Input.is_action_pressed('right')) - int(Input.is_action_pressed('left'))
	move_dir = Vector2(move_dir_x, move_dir_y).normalized()

func _apply_movement(delta):
	acceleration = move_dir * MOVE_SPEED * delta
	velocity += acceleration.clamped(MAX_SPEED)
	velocity = move_and_slide(velocity)

func _apply_friction(delta):
	velocity = velocity.linear_interpolate(Vector2.ZERO, FRICTION * delta)

func _handle_shooting():
	if Input.is_action_pressed('shoot') and can_shoot:
		can_shoot = false
		var bullet_instance = bullet_scene.instance()
		bullet_instance.position = bullet_start_position.get_global_position()
		bullet_instance.direction = -(self.global_position - get_global_mouse_position()).normalized()
		bullet_instance.damage = DAMAGE
		get_tree().get_root().add_child(bullet_instance)
		yield(get_tree().create_timer(SHOOT_DELAY), "timeout")
		can_shoot = true

func get_soul():
	souls += 1
	
	print('got soul')

func sacrifice_souls():
	if souls == 0 or !can_sacrifice_souls:
		return
	var god = get_tree().get_nodes_in_group('god')[0]
	send_soul((god.global_position - global_position).normalized())
	god.receive_soul()
	souls -= 1

func send_soul(direction):
	pass