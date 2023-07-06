extends Control

class_name SceneBase

# Emit this signal to let staging know we should return to our menu scene
signal exit_to_main_menu

# Emit this signal to let staging know we should load the specified scene
signal load_scene


export var min_size_margin : int = 15
export var min_size_x_multiplier : float = 1.0
export var min_size_y_multiplier : float = 0.0


func scene_loaded():
	#rect_min_size.y = $VBoxContainer.rect_size.y
	pass

func scene_exiting():
	# called when we're about to remove this scene
	pass


func _ready():
	var _error = get_viewport().connect("size_changed", self, "on_viewport_resize")
	on_viewport_resize()


func on_viewport_resize():
	var viewport_size = get_viewport().size
	var size = viewport_size * Vector2(min_size_x_multiplier, min_size_y_multiplier) - Vector2(2 * min_size_margin, 2 * min_size_margin)
	rect_min_size = size
