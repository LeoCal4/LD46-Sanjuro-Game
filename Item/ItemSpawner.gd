extends Node2D

export(Array, PackedScene) var items = []

var time_since_last_spawn = 0

func _ready():
	randomize()

func _physics_process(delta):
	time_since_last_spawn += delta
	if time_since_last_spawn >= Globals.item_spawn_delay:
		var random_spawner_index = randi() % get_child_count()
		spawn_item(get_child(random_spawner_index).position)
		time_since_last_spawn = 0


func spawn_item(position):
	items.shuffle()
	var item_scene = items.front()
	var item = item_scene.instance()
	item.position = position
	get_tree().get_root().get_node("/root/Scene1/YSort/").call_deferred('add_child', item)