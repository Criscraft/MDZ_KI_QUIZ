extends CanvasItem

export var screen_width_threshold : int = 600

func _ready():
	var _error = get_viewport().connect("size_changed", self, "on_viewport_resize")
	on_viewport_resize()
	

func on_viewport_resize():
	var size = get_viewport().size
	if size.x < screen_width_threshold:
		visible = false
	else:
		visible = true
