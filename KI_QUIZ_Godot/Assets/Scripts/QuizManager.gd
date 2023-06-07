extends Node

@export var question_file_path : String = "res://Data/quiz_questions.json"
@export var game_running : bool = false

var url_base : String = "http://localhost:3000/"
var url_start_game : String = url_base + "startgame/jsonVersion/"
var url_quizevent : String = url_base + "quizevent"

var questions_selected : Array[QuestionResource]
var points : int = 0
var active_question_ind : int = -1
var question_resources : Array[QuestionResource]
var current_question_correct : bool
var http_requester : HTTPRequest = null
var json_version : String = ""
var game_session_id : String = ""

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
	
	json_version = question_file["json_version_id"]
	
	for item in question_file["questions"]:
		question_resources.append(dict_to_question_resource(item))
		
	http_requester = HTTPRequest.new()
	add_child(http_requester)
	http_requester.request_completed.connect(_on_request_completed)


func _on_request_completed(result, response_code, headers, body):
	if response_code != 200:
		return
	var json = JSON.parse_string(body.get_string_from_utf8())
	if json["topic"] == "startgame":
		game_session_id = json["game_session_id"]
		print("Game session started with id " + game_session_id)
	

func start_new_game(n_questions : int = 2):
	if game_running:
		# A game is already running.
		return
	game_running = true
	print(url_start_game + json_version)
	http_requester.request(url_start_game + json_version, [], HTTPClient.METHOD_GET, "")
	
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
	
	
func report_result(choice : int):
	var current_question = questions_selected[active_question_ind]
	var correct_answer_ind = current_question.correct_answer
	current_question_correct = choice == correct_answer_ind
	if current_question_correct:
		points += 1
	
	if game_session_id:
		var headers = ["Content-Type: application/json"]
		var data_to_send = {
			"question_id" : current_question.id,
			"gamesession_id" : game_session_id,
			"option_chosen" : choice,
			"option_correct" : current_question.correct_answer,
		}
		var json = JSON.stringify(data_to_send)
		http_requester.request(url_quizevent, headers, HTTPClient.METHOD_POST, json)
		
		
func get_result():
	return [points, questions_selected.size()]
	

func get_progress():
	return [active_question_ind, questions_selected.size()]
	
	
func end_game():
	questions_selected = []
	points = 0
	active_question_ind = -1
	game_running = false
	game_session_id = ""
	
