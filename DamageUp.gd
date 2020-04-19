extends "Item/Item.gd"

func _on_DamageUp_body_entered(body):
	if body == get_tree().get_nodes_in_group('player')[0]:
		body.set_damage(10)
		queue_free()
