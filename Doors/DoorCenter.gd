extends "res://Doors/Door.gd"

func enable_player_donation(body):
	body.can_donate_souls_to_door3 = true

func disable_player_donation(body):
	body.can_donate_souls_to_door3 = false