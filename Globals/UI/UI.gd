extends CanvasLayer

func _ready():
	disable_buttons()

func disable_buttons():
	for button in get_children():
		button.visible = false

func activate_buttons():
	for button in get_children():
		button.visible = true

func _on_Button_button_down():
	if !SceneLoader.is_loading_scene:
		SceneLoader.reload_scene()

func _on_Button2_button_up():
	Globals.sound = !Globals.sound
