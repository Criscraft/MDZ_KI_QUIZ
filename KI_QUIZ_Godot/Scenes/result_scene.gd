extends SceneBase
class_name ResultScene

@onready var result_label = $VBoxContainer/ResultLabel
@onready var correct_answer_label = $VBoxContainer/CorrectAnswer
@onready var explanation_label = $VBoxContainer/Explanation
@onready var change_scene_button = $VBoxContainer/ChangeSceneButton

@export var question_scene_path : String = "res://Scenes/question_scene.tscn"
@export var final_result_scene_path : String = "res://Scenes/final_result_scene.tscn"

var current_question_resource : QuestionResource


func scene_loaded():
	# Called after scene is loaded
	current_question_resource = QuizManager.get_current_question_resource()
	update_results()


func scene_exiting():
	# called when we're about to remove this scene
	pass
	
	
func update_results():
	if QuizManager.current_question_correct:
		result_label.text = "Korrekt! Die richtige Antwort lautet:"
	else:
		result_label.text = "Leider falsch! Die richtige Antwort lautet:"
	
	correct_answer_label.text = current_question_resource.answers[current_question_resource.correct_answer]
	
	explanation_label.text = current_question_resource.explanation
		
	var progress = QuizManager.get_progress()
	if progress[0] < progress[1] - 1:
		change_scene_button.text = "Zur nächsten Frage!"
		change_scene_button.target_scene_path = question_scene_path
	else:
		change_scene_button.text = "Zu den Ergebnissen!"
		change_scene_button.target_scene_path = final_result_scene_path
	
