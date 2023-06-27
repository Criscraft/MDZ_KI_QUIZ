extends VBoxContainer

export var screen_width_threshold_for_column : int = 1050
export var screen_width_threshold_min_for_option_size : int = 350
export var screen_width_threshold_max_for_option_size : int = 550
export var option_size_small = 300
export var option_size_large = 500
onready var grid_container = $CenterContainer/GridContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	var _error = get_viewport().connect("size_changed", self, "on_viewport_resize")
	on_viewport_resize()
	

func on_viewport_resize():
	var size = get_viewport().size
	if size.x > screen_width_threshold_for_column:
		grid_container.columns = 2
	else:
		grid_container.columns = 1
	var factor = ( size.x - screen_width_threshold_min_for_option_size ) / ( screen_width_threshold_max_for_option_size - screen_width_threshold_min_for_option_size )
	factor = clamp(factor, 0.0, 1.0)
	set_option_sizes(option_size_small + factor * (option_size_large - option_size_small))


func set_option_sizes(size):
	$CenterContainer/GridContainer/ChoiceA.rect_min_size.x = size
	$CenterContainer/GridContainer/ChoiceB.rect_min_size.x = size
	$CenterContainer/GridContainer/ChoiceC.rect_min_size.x = size
	$CenterContainer/GridContainer/ChoiceD.rect_min_size.x = size
