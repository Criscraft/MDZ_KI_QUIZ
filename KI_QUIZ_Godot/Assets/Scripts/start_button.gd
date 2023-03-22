extends Button

## Scene base for the current scene
@export 
var scene_base: NodePath

## Scene to teleport to, or none for main menu
@export 
var scene: PackedScene

# Scene base to trigger loading
@onready 
var _scene_base : SceneBase = get_node(scene_base)


func _on_pressed():
	# Skip if scene base is not known
	print("press")
	if not _scene_base:
		return

	if scene:
		_scene_base.emit_signal("load_scene", scene.resource_path)
	else:
		_scene_base.emit_signal("exit_to_main_menu")
