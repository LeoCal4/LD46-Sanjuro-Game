extends Node2D


func _on_Door_tree_exiting():
	get_child(0).visible = false


func _on_DoorRight_tree_exiting():
	get_child(1).visible = false


func _on_DoorCenter_tree_exiting():
	get_child(2).visible = false
