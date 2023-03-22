extends Control

var current_scene : SceneBase
var current_scene_path : String

func _on_exit_to_main_menu():
	load_scene("res://scenes/main_menu/main_menu_level.tscn")

func _on_load_scene(p_scene_path : String):
	load_scene(p_scene_path)
	
func _add_signals(p_scene : SceneBase):
	p_scene.exit_to_main_menu.connect(_on_exit_to_main_menu)
	p_scene.load_scene.connect(_on_load_scene)

func _remove_signals(p_scene : SceneBase):
	p_scene.exit_to_main_menu.disconnect(_on_exit_to_main_menu)
	p_scene.load_scene.disconnect(_on_load_scene)

func load_scene(p_scene_path : String):
	# Check if it's already loaded...
	if p_scene_path == current_scene_path:
		return

	if current_scene:
		# Start by unloading our scene
		
		# First remove signals
		_remove_signals(current_scene)
		
		# Fade to loading screen
		var tween = create_tween()
		tween.tween_property($LoadingScreen, "self_modulate", Color(1.0, 1.0, 1.0, 1.0), 1.0)
		await tween.finished
		
		# Now we remove our scene
		current_scene.scene_exiting()
		$Scene.remove_child(current_scene)
		current_scene.queue_free()
		current_scene = null
	
	# Attempt to load our scene
	var new_scene = load(p_scene_path)
	
	# Setup our new scene
	current_scene = new_scene.instantiate()
	current_scene_path = p_scene_path
	$Scene.add_child(current_scene)
	_add_signals(current_scene)
	
	# Fade to visible
	var tween = create_tween()
	tween.tween_property($LoadingScreen, "self_modulate", Color(1.0, 1.0, 1.0, 0.0), 1.0)
	await tween.finished

func _ready():
	# We start by loading our start scene
	load_scene("res://Scenes/start_scene.tscn")
