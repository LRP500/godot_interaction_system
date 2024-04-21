extends Node

@export var fullscreen_input := "toggle_fullscreen"

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(fullscreen_input):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)