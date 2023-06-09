extends Control

class_name SceneBase

# Emit this signal to let staging know we should return to our menu scene
signal exit_to_main_menu

# Emit this signal to let staging know we should load the specified scene
signal load_scene

func scene_loaded():
	# Called after scene is loaded
	pass

func scene_exiting():
	# called when we're about to remove this scene
	pass
