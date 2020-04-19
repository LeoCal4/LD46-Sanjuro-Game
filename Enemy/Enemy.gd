extends KinematicBody2D

const MOVE_SPEED = 5
const MAX_SPEED = 100
const FULL_HP = 100
const FRICTION = 0
const KNOCKBACK = 100

const soul_scene = preload("res://Soul/Soul.tscn")

onready var map_navigation = get_tree().get_nodes_in_group('navigation2d')[0]
onready var sprite = $Sprite
onready var damage_sprite = $DamageSprite
onready var anim_player = $AnimationPlayer

var target
var hp = FULL_HP setget set_hp
var damage = 20
var motion
var acceleration
var knockback
var can_move = false
var can_attack = false
var can_be_damaged = false

signal camera_shake_requested

func _ready():
	add_to_group('enemies')
	motion = Vector2.ZERO
	acceleration = Vector2.ZERO
	knockback = Vector2.ZERO
	connect("camera_shake_requested", get_tree().get_nodes_in_group('camera')[0], 'shake')
	$CollisionShape2D.disabled = true
	if !map_navigation:
		map_navigation = get_tree().get_nodes_in_group('navigation2d')[0]

func _physics_process(delta):
	if target == null:
		target = get_tree().get_nodes_in_group('player')[0]
	if can_move:
		search(delta)
	if knockback != Vector2():
		knockback = knockback.linear_interpolate(Vector2(), 0.5)

func search(delta):
	var starting_point = self.global_position
	if !is_instance_valid(target) or target.is_queued_for_deletion():
		if !SceneLoader.is_loading_scene:
			target = get_tree().get_nodes_in_group('player')[0]
		return
	if (target.global_position.distance_to(starting_point)) >= 500 or !is_instance_valid(map_navigation) or !map_navigation.has_method("get_simple_path"):
		return
	var path_to_player = map_navigation.get_simple_path(starting_point, target.global_position)
	var move_distance = MOVE_SPEED * delta
	for point in range(path_to_player.size()):
		var distance_to_next_point = starting_point.distance_to(path_to_player[point])
		if move_distance <= distance_to_next_point:
			var move_rotation = get_angle_to(starting_point.linear_interpolate(path_to_player[point], move_distance / distance_to_next_point))
			acceleration = Vector2(MOVE_SPEED, 0).rotated(move_rotation) 
			acceleration = acceleration.linear_interpolate(Vector2.ZERO, FRICTION * delta)
			motion += acceleration + knockback
			motion = move_and_slide(motion).clamped(MAX_SPEED)
			break
		move_distance -= distance_to_next_point
		starting_point = path_to_player[point]
	if motion != Vector2() and !anim_player.is_playing():
		anim_player.play('move')

func receive_damage(damage, knockback_direction, source):
	if !can_be_damaged:
		return
	target = source
	if Globals.sound:
		$DamageSound.play()
	emit_signal('camera_shake_requested')
	knockback = knockback_direction * KNOCKBACK
	anim_player.stop()
	sprite.visible = false
	damage_sprite.visible = true
	set_hp(damage)

	yield(get_tree().create_timer(0.1), 'timeout')
	sprite.visible = true
	damage_sprite.visible = false

func die():
	var soul = soul_scene.instance()
	soul.position = position
	get_tree().get_root().call_deferred('add_child', soul)
	Globals.add_enemy_killed()
	queue_free()

func set_hp(damage):
	hp -= damage
	if hp <= 0:
		die()

func _on_PlayerHitArea_body_entered(body):
	if !can_attack:
		return
	if body == target:
		var knockback_direction = (body.global_position - global_position).normalized()
		body.receive_damage(damage, knockback_direction, self)
		knockback -= knockback_direction * KNOCKBACK

func complete_spawn():
	can_attack = true
	can_move = true
	can_be_damaged = true
	$CollisionShape2D.disabled = false
	$Spawn.visible = false
	$Sprite.visible = true
	$Shadow.visible = true