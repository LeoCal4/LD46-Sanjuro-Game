extends "res://Item/Item.gd"

func _on_DamageUp_body_entered(body):
	if body == get_tree().get_nodes_in_group('player')[0] and !is_getting_picked:
		body.set_damage(10)
		get_picked_up()
