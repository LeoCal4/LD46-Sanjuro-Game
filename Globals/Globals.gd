extends Node

const DEBUG = false
var sound = true
var enemy_spawn_delay = 5
var enemies_killed = 0
var decay_multiplicator = 1


func add_enemy_killed():
	enemies_killed += 1
	if enemies_killed % 10 == 0:
		enemy_spawn_delay = max(enemy_spawn_delay - 0.25, 1.5)
		print("current spawn delay: " + str(enemy_spawn_delay))
		decay_multiplicator += 0.1