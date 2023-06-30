extends Control

export var margin_l : int = 10
export var margin_r : int = 10

func _ready():
	var _error = get_viewport().connect("size_changed", self, "on_viewport_resize")
	on_viewport_resize()
	#pass

func on_viewport_resize():
	var viewport_size = get_viewport().size
	var size = viewport_size.x - (margin_l + margin_r)
	rect_min_size.x = size
