extends "Item/Item.gd"


func _on_SoulContainer_body_entered(body):
	if body == get_tree().get_nodes_in_group('player')[0]:
		body.set_max_souls(1)
		queue_free()
