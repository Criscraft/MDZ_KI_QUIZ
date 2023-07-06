extends SceneBase
class_name ResultScene

export var color_correct : Color
export var color_incorrect : Color

onready var result_label = $PanelContainer/ResultLabel
onready var correct_answer_label = $CorrectAnswer
onready var explanation_label = $Explanation
onready var change_scene_button = $ChangeSceneButton
onready var result_panel_container = $PanelContainer

export var question_scene_path : String = "res://Scenes/question_scene.tscn"
export var final_result_scene_path : String = "res://Scenes/final_result_scene.tscn"

var current_question_resource : Resource


func scene_loaded():
	# Called after scene is loaded
	.scene_loaded()
	current_question_resource = QuizManager.get_current_question_resource()
	update_results()


func scene_exiting():
	# called when we're about to remove this scene
	pass
	
	
func update_results():
	if QuizManager.current_question_correct:
		result_label.text = "Korrekt! Die richtige Antwort lautet:"
		result_panel_container.get("custom_styles/panel").bg_color = color_correct
	else:
		result_label.text = "Leider falsch! Die richtige Antwort lautet:"
		result_panel_container.get("custom_styles/panel").bg_color = color_incorrect
	
	correct_answer_label.text = current_question_resource.answers[current_question_resource.correct_answer]
	
	explanation_label.text = current_question_resource.explanation
		
	var progress = QuizManager.get_progress()
	if progress[0] < progress[1] - 1:
		change_scene_button.text = "Zur nächsten Frage!"
		change_scene_button.target_scene_path = question_scene_path
	else:
		change_scene_button.text = "Zu den Ergebnissen!"
		change_scene_button.target_scene_path = final_result_scene_path
	
