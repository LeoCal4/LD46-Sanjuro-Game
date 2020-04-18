extends Node2D

export(Array, PackedScene) var enemies = []

var time_since_last_spawn = 0

func _ready():
	randomize()

func _physics_process(delta):
	time_since_last_spawn += delta
	if time_since_last_spawn >= Globals.enemy_spawn_delay:
		var random_spawner_index = randi() % get_child_count()
		spawn_enemy(get_child(random_spawner_index).position)
		time_since_last_spawn = 0
		print('enemy spawned')


func spawn_enemy(position):
	# play windup animation
	enemies.shuffle()
	var enemy_scene = enemies.front()
	var enemy = enemy_scene.instance()
	enemy.position = position
	get_tree().get_root().call_deferred('add_child', enemy)