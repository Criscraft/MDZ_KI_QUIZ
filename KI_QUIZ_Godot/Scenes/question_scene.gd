extends SceneBase
class_name QuestionScene

## Scene base for the current scene
@export var scene_base: NodePath

## Scene to teleport to, or none for main menu
@export var scene: PackedScene

# Scene base to trigger loading
@onready var _scene_base : SceneBase = get_node(scene_base)

@onready var question = $VBoxContainer/Question
@onready var choice_a = $VBoxContainer/CenterContainer/GridContainer/ChoiceA
@onready var choice_b = $VBoxContainer/CenterContainer/GridContainer/ChoiceB
@onready var choice_c = $VBoxContainer/CenterContainer/GridContainer/ChoiceC
@onready var choice_d = $VBoxContainer/CenterContainer/GridContainer/ChoiceD

var choices = []
var current_question_resource : QuestionResource
var question_answers : Array # shuffled array with options

func _ready():
	choices = [choice_a, choice_b, choice_c, choice_d]
	
	
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
	# Update the question
	question.text = current_question_resource.question
	
	# Update the choices
	# First, we shuffle the order of the choices
	question_answers = current_question_resource.answers.duplicate()
	#var answer = question_answers[current_question_resource.correct_answer]
	question_answers.shuffle()
	choice_a.get_node("Label").text = question_answers[0]
	choice_b.get_node("Label").text = question_answers[1]
	choice_c.get_node("Label").text = question_answers[2]
	choice_d.get_node("Label").text = question_answers[3]
	
	
func _on_choice_pressed(choice : int):
	# The player has made his choice.
	
	# Disable the buttons.
	for button in choices:
		button.disabled = true
		
	var correct = QuizManager.check_result(question_answers[choice])
	var tween = choices[choice].animate_result(correct)
	await tween.finished
	
	tween = create_tween()
	tween.tween_property(self, "", null, 1.0)
	await tween.finished
	
	# Initiate loading of result scene
	if not _scene_base:
		return
	if scene:
		_scene_base.emit_signal("load_scene", scene.resource_path)
	else:
		_scene_base.emit_signal("exit_to_main_menu")

	
