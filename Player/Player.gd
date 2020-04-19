extends KinematicBody2D

const FRICTION = 10
const KNOCKBACK = 100

var max_souls = 3
var base_damage = 20
var max_damage = 100
var base_move_speed = 3000
var max_move_speed = base_move_speed * 12
var base_shoot_delay = 0.3
var min_shoot_delay = 0.1
var max_health = 100

var move_speed = base_move_speed
var shoot_delay = 0.3

var damage = base_damage

var souls = 0 setget set_souls

onready var bullet_start_position = $BulletStartPosition
onready var damage_sprite = $DamageSprite
onready var health_bar = get_node('/root/UI').get_child(3)
onready var souls_label = get_node('/root/UI').get_child(4)
onready var sprite = $Sprite
onready var soul_sacrifice_label = $SoulSacrificeLabel
onready var shoot_sound = $ShootSound
const bullet_scene = preload("res://Player/Bullet/Bullet.tscn")

var health = max_health
var move_dir
var velocity
var acceleration
var knockback
var shoot_delay_timer
var can_move = true
var can_shoot
var can_sacrifice_souls = false
var is_berserk = false

func _ready():
	health = max_health
	move_dir = Vector2(0, 0)
	velocity = Vector2(0, 0)
	acceleration = Vector2.ZERO
	knockback = Vector2.ZERO
	shoot_delay_timer = get_tree().create_timer(shoot_delay)
	can_shoot = true
	yield(get_tree(), 'idle_frame')
	get_tree().call_group('enemies', 'set_player', self)
	if (is_instance_valid(health_bar)):
		health_bar.value = 100
	if (is_instance_valid(souls_label)):
		souls_label.text = str(souls) + " / " + str(max_souls)
	

func _physics_process(delta):
	_handle_movement_input()
	_handle_shooting()
	_apply_movement(delta)
	_apply_friction(delta)
	if Input.is_action_just_pressed('action'):
		if can_sacrifice_souls:
			sacrifice_souls()
	if knockback != Vector2():
		knockback = knockback.linear_interpolate(Vector2(), 0.5)
	#look_at(get_global_mouse_position())

func _handle_movement_input():
	if !can_move:
		return
	move_dir = Vector2.ZERO
	var move_dir_y = int(Input.is_action_pressed('down')) - int(Input.is_action_pressed('up'))
	var move_dir_x = int(Input.is_action_pressed('right')) - int(Input.is_action_pressed('left'))
	move_dir = Vector2(move_dir_x, move_dir_y).normalized()

func _apply_movement(delta):
	acceleration = move_dir * move_speed * delta
	velocity += acceleration.clamped(max_move_speed) + knockback
	velocity = move_and_slide(velocity)

func _apply_friction(delta):
	velocity = velocity.linear_interpolate(Vector2.ZERO, FRICTION * delta)

func _handle_shooting():
	if Input.is_action_pressed('shoot') and can_shoot:
		can_shoot = false
		var bullet_instance = bullet_scene.instance()
		bullet_instance.position = bullet_start_position.get_global_position()
		bullet_instance.direction = -(self.global_position - get_global_mouse_position()).normalized()
		bullet_instance.damage = damage
		bullet_instance.parent = self
		get_tree().get_root().add_child(bullet_instance)
		if Globals.sound:
			shoot_sound.play()
		yield(get_tree().create_timer(shoot_delay), "timeout")
		can_shoot = true

func get_soul():
	if souls >= max_souls:
		return
	if Globals.sound:
		$PickSoulSound.play()
	set_souls(1)
	change_stats(1)
	print('got soul')

func sacrifice_souls():
	if souls == 0 or !can_sacrifice_souls:
		return
	var god = get_tree().get_nodes_in_group('god')[0]
	god.receive_soul()
	change_stats(-1)
	set_souls(-1)

# factor: number of souls and if they're lost or gained
func change_stats(factor):
	damage = clamp(damage + 5 * factor, base_damage, max_damage)
	move_speed = clamp(move_speed + 150 * factor, base_move_speed, max_move_speed)
	shoot_delay = clamp(shoot_delay - 0.02 * factor, min_shoot_delay, base_shoot_delay) 
	scale = scale + Vector2(0.1, 0.1) * factor
	print('stats changed: ' + str(factor))

func activate_berserk_mode():
	if !is_berserk and $BerserkTimer.time_left <= 0:
		$BerserkTimer.wait_time = 10
		is_berserk = true
		change_stats(7)

func deactivate_berserk_mode():
	if is_berserk:
		is_berserk = false
		change_stats(-7)
		$BerserkTimer.start()

func receive_damage(amount, knockback_direction, source):
	set_hp(-amount)
	knockback = knockback_direction * KNOCKBACK
	sprite.visible = false
	damage_sprite.visible = true
	if Globals.sound:
		$DamageSound.play()
	yield(get_tree().create_timer(0.1), 'timeout')
	sprite.visible = true
	damage_sprite.visible = false

func set_hp(amount):
	health += amount
	health_bar.value = health
	if health <= 0:
		can_move = false
		SceneLoader.reload_scene()

func set_souls(amount):
	souls += amount
	souls_label.text = str(souls) + " / " + str(max_souls)