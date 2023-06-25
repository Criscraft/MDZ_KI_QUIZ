extends Button

## Scene base for the current scene
export var scene_base: NodePath

## Scene to teleport to, or none for main menu
export var target_scene_path: String = "res://Scenes/question_scene.tscn"

# Scene base to trigger loading
onready var _scene_base : SceneBase = get_node(scene_base)


func _on_pressed():
	disabled = true
	# Skip if scene base is not known
	if not _scene_base:
		return

	if target_scene_path:
		_scene_base.emit_signal("load_scene", target_scene_path)
	else:
		_scene_base.emit_signal("exit_to_main_menu")
		
