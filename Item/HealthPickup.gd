extends "res://Item/Item.gd"

func _on_HealthPickup_body_entered(body):
	if body == get_tree().get_nodes_in_group('player')[0] and body.health < body.max_health and !is_getting_picked:
		body.set_hp(20)
		get_picked_up()