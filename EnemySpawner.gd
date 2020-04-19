extends Node2D

export(Array, PackedScene) var enemies = []

var time_since_last_spawn = 0

func _ready():
	randomize()

func _physics_process(delta):
	time_since_last_spawn += delta
	if time_since_last_spawn >= Globals.enemy_spawn_delay and Globals.alive_enemies <= Globals.max_enemies:
		var random_spawner_index1 = randi() % get_child_count()
		var random_spawner_index2 = randi() % get_child_count()
		spawn_enemy(get_child(random_spawner_index1).position)
		spawn_enemy(get_child(random_spawner_index2).position)
		time_since_last_spawn = 0
		Globals.alive_enemies += 1


func spawn_enemy(position):
	# play windup animation
	enemies.shuffle()
	var enemy_scene = enemies.front()
	var enemy = enemy_scene.instance()
	enemy.position = position
	get_tree().get_root().get_node("/root/Scene1/YSort/").call_deferred('add_child', enemy)


func _on_Door_open_door():
	enemies.append(load('res://Enemy/BiEnemy.tscn'))


func _on_DoorRight_open_door():
	enemies.append(load('res://Enemy/BigRangedEnemy.tscn'))