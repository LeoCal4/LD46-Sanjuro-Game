extends "res://Item/Item.gd"


func _on_SoulContainer_body_entered(body):
	if body == get_tree().get_nodes_in_group('player')[0] and !is_getting_picked:
		body.set_max_souls(1)
		get_picked_up()
