extends Node

@export var question_file_path : String = "Data/quiz_questions.json"

@export var game_running : bool = false

var questions_selected : Array[QuestionResource]
var points : int = 0
var active_question_ind : int = -1
var question_resources : Array[QuestionResource]
var current_question_correct : bool

func load_json(path):
	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_as_text()
	var json = JSON.new()
	var error = json.parse(content)
	if error == OK:
		return json.data
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", content, " at line ", json.get_error_line())
		return

	
func dict_to_question_resource(dic : Dictionary):
	var question_resource = QuestionResource.new()
	question_resource.id = dic["id"]
	question_resource.question = dic["question"]
	question_resource.answers = dic["answers"]
	question_resource.correct_answer = int(dic["correct_answer"])
	question_resource.explanation = dic["explanation"]
	return question_resource


# Called when the node enters the scene tree for the first time.
func _ready():
	var question_file = load_json(question_file_path)
	
	for item in question_file:
		question_resources.append(dict_to_question_resource(item))


func start_new_game(n_questions : int = 2):
	if game_running:
		# A game is already running.
		return
	game_running = true
	question_resources.shuffle()
	questions_selected = question_resources.slice(0, n_questions)
	active_question_ind = -1
	
	
func get_next_question_resource():
	active_question_ind += 1
	if active_question_ind == questions_selected.size():
		# There is no question left. The quiz is about to end.
		return
	return questions_selected[active_question_ind]
	
	
func get_current_question_resource():
	return questions_selected[active_question_ind]
	
	
func check_result(answer : String):
	var current_question = questions_selected[active_question_ind]
	var answer_ind = current_question.answers.find(answer)
	var correct_answer_ind = current_question.correct_answer
	current_question_correct = answer_ind == correct_answer_ind
	if current_question_correct:
		points += 1
	return current_question_correct
		
		
func get_result():
	return [points, questions_selected.size()]
	

func get_progress():
	return [active_question_ind, questions_selected.size()]
	
	
func end_game():
	questions_selected = []
	points = 0
	active_question_ind = -1
	game_running = false
	
