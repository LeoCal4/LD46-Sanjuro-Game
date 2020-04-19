extends "Item/Item.gd"

func _on_HealthPickup_body_entered(body):
	if body == get_tree().get_nodes_in_group('player')[0] and body.health < body.max_health:
		body.set_hp(10)
		queue_free()