extends Node

var is_loading_scene = false

onready var UI = get_node('/root/UI')
onready var fade_player = get_node('/root/Shaders').get_child(0).get_child(0).get_child(0)


func reload_scene():
	is_loading_scene = true
	_disable_ui()
	fade_player.play("fade")
	yield(fade_player, 'animation_finished')
	fade_player.play_backwards("fade")
	get_tree().call_deferred('reload_current_scene')
	yield(fade_player, 'animation_finished')
	_activate_ui()
	is_loading_scene = false


func load_scene(scene_path):
	call_deferred('_deferred_load_scene', scene_path)


func _deferred_load_scene(scene_path):
	is_loading_scene = true
	_disable_ui()
	fade_player.play("fade")
	get_tree().get_current_scene().free()
	var scene = ResourceLoader.load(scene_path).instance()
	yield(fade_player, 'animation_finished')
	fade_player.play_backwards("fade")
	get_tree().get_root().add_child(scene)
	get_tree().set_current_scene(scene)
	yield(fade_player, 'animation_finished')
	_activate_ui()
	is_loading_scene = false


func _disable_ui():
	UI.disable_buttons()
	for enemy in get_tree().get_nodes_in_group('enemies'):
		enemy.queue_free()


func _activate_ui():
	UI.activate_buttons()
