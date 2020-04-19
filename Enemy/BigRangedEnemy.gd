extends "res://Enemy/Enemy.gd"

var bullet_scene = preload("res://Enemy/EnemyBullet/EnemyBullet.tscn")

var bullet_damage = 25
var shooting_delay = 1
var time = 0

onready var raycast = $RayCast2D

func _ready():
	collision_shape = $CollisionShape2D2
	hp = 250
	damage = 15


func spawn_souls():
	for i in range(3):
		var soul = soul_scene.instance()
		soul.position = position + Vector2(i * 4, i * 4)
		get_tree().get_root().get_node("/root/Scene1/YSort/").call_deferred('add_child', soul)


func _process(delta):
	time += delta
	#var player = get_tree().get_nodes_in_group('player')[0]
	if !is_instance_valid(target) or target.is_queued_for_deletion():
		if !SceneLoader.is_loading_scene:
			target = get_tree().get_nodes_in_group('player')[0]
		return
	if (target.global_position.distance_to(global_position)) >= 200 and time >= shooting_delay and can_attack:
		var direction = (target.global_position - global_position).normalized()
		raycast.cast_to = direction * 200
		raycast.force_raycast_update()
		if raycast.get_collider() == target:
			var bullet = bullet_scene.instance()
			bullet.position = self.global_position
			direction = (target.global_position - self.global_position).normalized()
			bullet.direction = direction
			bullet.parent = self
			bullet.damage = bullet_damage
			bullet.scale *= 2
			get_tree().get_root().get_node("/root/Scene1/YSort/").add_child(bullet)
			if Globals.sound:
				$ShootSound.play()
			time = 0