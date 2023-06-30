extends SceneBase
class_name QuestionScene

## Scene base for the current scene
export var scene_base: NodePath

## Scene to teleport to, or none for main menu
export var scene: PackedScene

# Scene base to trigger loading
onready var _scene_base : SceneBase = get_node(scene_base)

onready var question_label = $VBoxContainer/Question
onready var choice_a = $VBoxContainer/CenterContainer/GridContainer/ChoiceA
onready var choice_b = $VBoxContainer/CenterContainer/GridContainer/ChoiceB
onready var choice_c = $VBoxContainer/CenterContainer/GridContainer/ChoiceC
onready var choice_d = $VBoxContainer/CenterContainer/GridContainer/ChoiceD

onready var progress_label = $VBoxContainer/Progress

var current_question_resource : QuestionResource
var choice_permutation : Array # shuffled array for choices
var choices = []

func _ready():
	choices = [choice_a, choice_b, choice_c, choice_d]
	
	
func scene_loaded():
	# Called after scene is loaded
	.scene_loaded()
	# Get the next question
	current_question_resource = QuizManager.get_next_question_resource()
	# Apply the question
	update_question()
	var progress = QuizManager.get_progress()
	progress_label.text = "Frage " + str(progress[0] + 1) + " von " + str(progress[1])

func scene_exiting():
	# called when we're about to remove this scene
	pass
	
	
func update_question():
	# Update the question
	question_label.text = current_question_resource.question
	
	# Update the choices
	# First, we shuffle the order of the choices
	choice_permutation = [0,1,2,3]
	choice_permutation.shuffle()
	choice_a.get_node("Label").text = current_question_resource.answers[choice_permutation[0]]
	choice_b.get_node("Label").text = current_question_resource.answers[choice_permutation[1]]
	choice_c.get_node("Label").text = current_question_resource.answers[choice_permutation[2]]
	choice_d.get_node("Label").text = current_question_resource.answers[choice_permutation[3]]
	
	
func _on_choice_pressed(choice : int):
	# The player has made his choice.
	
	# Disable the buttons.
	for button in choices:
		button.disabled = true
	
	var choice_index = choice_permutation[choice]
	QuizManager.report_result(choice_index)
	var correct = choice_index == current_question_resource.correct_answer
	
	var tween = choices[choice].animate_result(correct)
	if not correct:
		var correct_index = choice_permutation.find(current_question_resource.correct_answer)
		choices[correct_index].animate_result(true)
	tween.tween_property(self, "", null, 0.75)
	yield(tween, "finished")
	
	# Initiate loading of result scene
	if not _scene_base:
		return
	if scene:
		_scene_base.emit_signal("load_scene", scene.resource_path)
	else:
		_scene_base.emit_signal("exit_to_main_menu")
		
