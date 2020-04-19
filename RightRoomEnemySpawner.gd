extends Node2D

export(Array, PackedScene) var enemies = []

var time_since_last_spawn = 0
var can_spawn = false 

func _ready():
	randomize()
	if !can_spawn:
		set_physics_process(false)

func _physics_process(delta):
	time_since_last_spawn += delta
	if time_since_last_spawn >= Globals.enemy_left_room_spawn_delay:
		var random_spawner_index = randi() % get_child_count()
		spawn_enemy(get_child(random_spawner_index).position)
		time_since_last_spawn = 0


func spawn_enemy(position):
	# play windup animation
	enemies.shuffle()
	var enemy_scene = enemies.front()
	var enemy = enemy_scene.instance()
	enemy.position = position
	get_tree().get_root().get_node("/root/Scene1/YSort/").call_deferred('add_child', enemy)


func _on_Door_door_open():
	set_physics_process(true)