extends "Enemy.gd"

var can_attack = false
var bullet_scene = preload("res://Enemy/EnemyBullet/EnemyBullet.tscn")



var bullet_damage = 15
var shooting_delay = 1
var time = 0

onready var raycast = $RayCast2D

func _ready():
	._ready()
	damage = 10

func _process(delta):
	time += delta
	var player = get_tree().get_nodes_in_group('player')[0]
	if (player.global_position.distance_to(global_position)) >= 200 and time >= shooting_delay:
		var direction = (player.global_position - global_position).normalized()
		raycast.cast_to = direction * 200
		raycast.force_raycast_update()
		if raycast.get_collider() == player:
			var bullet = bullet_scene.instance()
			bullet.position = self.global_position
			direction = (player.global_position - self.global_position).normalized()
			bullet.direction = direction
			bullet.parent = self
			bullet.damage = bullet_damage
			get_tree().get_root().add_child(bullet)
			time = 0