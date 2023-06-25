extends Button

export var color_correct : Color
export var color_incorrect : Color


func animate_result(correct : bool):
	var color
	if correct:
		color = color_correct
	else:
		color = color_incorrect
	
	var tween = create_tween()
	tween.tween_property(self, "self_modulate", color, 0.5)
	return tween
