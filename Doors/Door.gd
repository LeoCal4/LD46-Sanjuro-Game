extends StaticBody2D

signal open_door

var souls = 0
export var souls_needed = 15

func _on_Area2D_body_entered(body):
	if body == get_tree().get_nodes_in_group('player')[0]:
		$Label.visible = true
		enable_player_donation(body)

func _on_Area2D_body_exited(body):
	if body == get_tree().get_nodes_in_group('player')[0]:
		$Label.visible = false
		disable_player_donation(body)

func enable_player_donation(body):
	body.can_donate_souls_to_door1 = true

func disable_player_donation(body):
	body.can_donate_souls_to_door1 = false

func receive_soul():
	souls += 1
	$Label.text = "Needed:\n" + str(souls_needed - souls) + " souls"
	if souls >= souls_needed:
		print('ao')
		emit_signal('open_door')
		queue_free()