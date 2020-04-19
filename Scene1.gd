extends Node2D

var custom_cursor = preload("res://Globals/Cursor.png")

func _ready():
	Input.set_custom_mouse_cursor(custom_cursor)

func _physics_process(delta):
	if Globals.sound:
		if !$BackgroundMusic.playing:
			$BackgroundMusic.play()
	else:
		$BackgroundMusic.stop()