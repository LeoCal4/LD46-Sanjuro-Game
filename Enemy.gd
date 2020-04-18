extends KinematicBody2D

const MOVE_SPEED = 5
const MAX_SPEED = 10
const FULL_HP = 10000

onready var map_navigation = get_parent().get_node('Navigation2D')
onready var sprite = $Sprite

var player
var hp = FULL_HP
var damage
var motion
var acceleration

func _ready():
	add_to_group('enemies')
	motion = Vector2.ZERO
	acceleration = Vector2.ZERO

func _physics_process(delta):
	if player == null:
		player = get_tree().get_nodes_in_group('player')[0]
	search(delta)

func search(delta):
	var starting_point = self.global_position
	var path_to_player = map_navigation.get_simple_path(starting_point, player.global_position)
	var move_distance = MOVE_SPEED * delta
	for point in range(path_to_player.size()):
		var distance_to_next_point = starting_point.distance_to(path_to_player[point])
		if move_distance <= distance_to_next_point:
			var move_rotation = get_angle_to(starting_point.linear_interpolate(path_to_player[point], move_distance / distance_to_next_point))
			acceleration = Vector2(MOVE_SPEED, 0).rotated(move_rotation) 
			motion += acceleration.clamped(MAX_SPEED)
			motion = move_and_slide(motion)
			break
		move_distance -= distance_to_next_point
		starting_point = path_to_player[point]

func set_player(p):
	player = p

func recieve_damage(damage, knockback_direction):
	hp -= damage
	acceleration = lerp(acceleration, knockback_direction * 5, 0.5)
	if hp <= 0:
		queue_free()
		return
	sprite.modulate.r = sprite.modulate.r + float(damage)/float(FULL_HP)
