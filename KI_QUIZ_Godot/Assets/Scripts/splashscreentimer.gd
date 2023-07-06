extends Timer

func _on_SplashScreenTimer_timeout():
	get_parent().emit_signal("load_scene", "res://Scenes/start_scene.tscn")
