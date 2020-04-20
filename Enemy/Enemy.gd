extends KinematicBody2D

export var MOVE_SPEED = 5
const MAX_SPEED = 100
const FULL_HP = 100
const FRICTION = 0
const KNOCKBACK = 100

const soul_scene = preload("res://Soul/Soul.tscn")

const health_scene = preload("res://Item/HealthPickup.tscn")

onready var map_navigation = get_tree().get_nodes_in_group('navigation2d')[0]
onready var sprite = $Sprite
onready var damage_sprite = $DamageSprite
onready var anim_player = $AnimationPlayer
onready var collision_shape = $CollisionShape2D

var target
var hp = FULL_HP setget set_hp
export var damage = 20
export var awake = true
var motion 
var acceleration
var knockback
var can_move = false
var can_attack = false
var can_be_damaged = false
var move_animation = 'move'

signal camera_shake_requested

func _ready():
	add_to_group('enemies')
	randomize()
	motion = Vector2.ZERO
	acceleration = Vector2.ZERO
	knockback = Vector2.ZERO
	connect("camera_shake_requested", get_tree().get_nodes_in_group('camera')[0], 'shake')
	collision_shape.disabled = true
	if !map_navigation:
		map_navigation = get_tree().get_nodes_in_group('navigation2d')[0]
	if awake:
		anim_player.play("spawn")

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
	if !is_instance_valid(map_navigation) or !map_navigation.has_method("get_simple_path") or (target.global_position.distance_to(starting_point)) >= 700:
		return
	var path_to_player = map_navigation.get_simple_path(starting_point, target.global_position)
	$Label.text = str(path_to_player.size())
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
		play_move_animation()
		

func play_move_animation():
	anim_player.play(move_animation)


func receive_damage(damage_received, knockback_direction, source):
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
	set_hp(damage_received)

	yield(get_tree().create_timer(0.1), 'timeout')
	sprite.visible = true
	damage_sprite.visible = false

func die():
	spawn_souls()
	spawn_health()
	Globals.alive_enemies -= 1
	Globals.add_enemy_killed()
	while ($DamageSound.is_playing()):
		yield(get_tree(), 'idle_frame')
	queue_free()

func spawn_souls():
	var soul = soul_scene.instance()
	soul.position = position
	get_tree().get_root().get_node("/root/Scene1/YSort/").call_deferred('add_child', soul)

func spawn_health():
	if randf() >= 0.8:
		var health = health_scene.instance()
		health.position = position + Vector2(5, 5)
		get_tree().get_root().get_node("/root/Scene1/YSort/").call_deferred('add_child', health)

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
	collision_shape.disabled = false
	$Spawn.visible = false
	sprite.visible = true
	$Shadow.visible = true

func wake():
	awake = true
	anim_player.play("spawn")