extends "Item/Item.gd"

func _on_Bow_body_entered(body):
	if body == get_tree().get_nodes_in_group('player')[0]:
		body.set_shoot_delay(0.05)
		queue_free()
