extends Node

var standard_font = preload("res://Assets/ThemesAndFonts/opensans_dynamicfont.tres")
var title_font = preload("res://Assets/ThemesAndFonts/opensans_dynamicfont_title.tres")

export var screen_width_threshold_min : int = 350
export var screen_width_threshold_max : int = 1000
export var font_size_small = 15
export var font_size_large = 30
export var font_size_title_small = 30
export var font_size_title_large = 60

func _ready():
	var _error = get_viewport().connect("size_changed", self, "on_viewport_resize")
	on_viewport_resize()
	

func on_viewport_resize():
	var size = get_viewport().size
	size = min(size.x, size.y)
	var factor = ( size - screen_width_threshold_min ) / ( screen_width_threshold_max - screen_width_threshold_min )
	factor = clamp(factor, 0.0, 1.0)
	
	var font_size = font_size_small + factor * (font_size_large - font_size_small)
	standard_font.size = font_size
	var font_size_title = font_size_title_small + factor * (font_size_title_large - font_size_title_small)
	title_font.size = font_size_title
