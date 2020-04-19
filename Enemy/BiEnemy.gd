extends "res://Enemy/Enemy.gd"


func _ready():
	collision_shape = $CollisionShape2D2
	move_animation = 'big_move'
	hp = 350
	damage = 30


func spawn_souls():
	for i in range(3):
		var soul = soul_scene.instance()
		soul.position = position + Vector2(i * 4, i * 4)
		get_tree().get_root().get_node("/root/Scene1/YSort/").call_deferred('add_child', soul)