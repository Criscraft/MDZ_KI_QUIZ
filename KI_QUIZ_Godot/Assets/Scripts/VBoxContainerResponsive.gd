extends VBoxContainer

@export var screen_width_threshold : int = 900
@onready var grid_container = $CenterContainer/GridContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	var error = get_viewport().size_changed.connect(on_viewport_resize)
	

func on_viewport_resize():
	var size = get_viewport().size
	if size.x > screen_width_threshold:
		grid_container.columns = 2
	else:
		grid_container.columns = 1
