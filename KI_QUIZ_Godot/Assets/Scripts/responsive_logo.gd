extends TextureRect


func _ready():
	var _error = get_viewport().connect("size_changed", self, "on_viewport_resize")
	on_viewport_resize()
	

func on_viewport_resize():
	var size = get_viewport().size
	var is_portrait_layout = size.y > size.x
	if is_portrait_layout:
		anchor_right = 0.7
	else:
		anchor_right = 0.4
