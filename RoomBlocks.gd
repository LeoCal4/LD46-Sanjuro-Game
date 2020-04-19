extends Node2D


func _on_Door_open_door():
	if !SceneLoader.is_loading_scene:
		get_child(0).visible = false
		var enemies = get_tree().get_root().get_node("/root/Scene1/YSort/FirstRoomEnemies/").get_children()
		for enemy in enemies:
			enemy.wake()


func _on_DoorRight_open_door():
	if !SceneLoader.is_loading_scene:
		get_child(1).visible = false
		var enemies = get_tree().get_root().get_node("/root/Scene1/YSort/SecondRoomEnemies/").get_children()
		for enemy in enemies:
			enemy.wake()


func _on_DoorCenter_open_door():
	if !SceneLoader.is_loading_scene:
		get_child(2).visible = false
		var enemies = get_tree().get_root().get_node("/root/Scene1/YSort/ThirdRoomEnemies/").get_children()
		for enemy in enemies:
			enemy.wake()