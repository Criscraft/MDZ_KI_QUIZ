extends SceneBase
class_name QuestionScene

@onready var question = $Panel/VBoxContainer/Question
@onready var option_a = $Panel/VBoxContainer/CenterContainer/GridContainer/ChoiceA
@onready var option_b = $Panel/VBoxContainer/CenterContainer/GridContainer/ChoiceB
@onready var option_c = $Panel/VBoxContainer/CenterContainer/GridContainer/ChoiceC
@onready var option_d = $Panel/VBoxContainer/CenterContainer/GridContainer/ChoiceD

var current_question_resource : QuestionResource
var correct_answer : int = -1

func scene_loaded():
	# Called after scene is loaded
	# Get the next question
	current_question_resource = QuizManager.get_next_question_resource()
	# Apply the question
	update_question()

func scene_exiting():
	# called when we're about to remove this scene
	pass
	
func update_question():
	question.text = current_question_resource.question
	var question_answers = current_question_resource.answers.duplicate()
	var answer = question_answers[current_question_resource.correct_answer]
	question_answers.shuffle()
	correct_answer = question_answers.find(answer)
	option_a.get_node("Label").text = question_answers[0]
	option_b.get_node("Label").text = question_answers[1]
	option_c.get_node("Label").text = question_answers[2]
	option_d.get_node("Label").text = question_answers[3]
	
	

	
