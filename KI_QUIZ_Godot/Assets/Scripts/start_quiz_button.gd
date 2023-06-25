extends "res://Assets/Scripts/change_scene_button.gd"

func _on_pressed():
	QuizManager.start_new_game(5)
	._on_pressed()
