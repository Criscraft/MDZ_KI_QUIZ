extends SceneBase
class_name FinalResultScene

onready var score_label = $VBoxContainer/Score


func scene_loaded():
	# Called after scene is loaded
	# Apply the question
	update_results()
	QuizManager.end_game()


func scene_exiting():
	# called when we're about to remove this scene
	pass
	
	
func update_results():
	var points = QuizManager.points
	var progress = QuizManager.get_progress()
	score_label.text = "Sie haben " + str(points) + " von " + str(progress[1]) + " Fragen richtig beantwortet."
	
