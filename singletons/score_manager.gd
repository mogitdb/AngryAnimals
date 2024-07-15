extends Node


const DEFAULT_SCORE: int = 1000
const SCORES_PATH = "user://animals.json"


var _level_selected: int = 1
var _level_scores: Dictionary = {}

'''
_level_scores = {
	"1": 8,
	"2": 4,
	"3": 7
}

_level_scores["1"] = 8
'''


# Called when the node enters the scene tree for the first time.
func _ready():
	load_from_disc()

func set_level_selected(ls: int) -> void:
	_level_selected = ls
	
	
	
func get_level_selected() -> int:
	return _level_selected


func check_and_add(level: String) -> void:
	if _level_scores.has(level) == false:
		_level_scores[level] = DEFAULT_SCORE


func set_score_for_level(score: int, level: String):
	check_and_add(level)
	if _level_scores[level] > score:
		_level_scores[level] = score
		save_to_disc()
		

func get_best_for_level(level: String) -> int:
	check_and_add(level)
	return _level_scores[level]


func save_to_disc():
	var file = FileAccess.open(SCORES_PATH, FileAccess.WRITE)
	var score_json_str = JSON.stringify(_level_scores)
	file.store_string(score_json_str)


func load_from_disc():
	var file = FileAccess.open(SCORES_PATH, FileAccess.READ)
	if file == null:
		save_to_disc()
		
	else:
		var data = file.get_as_text()
		_level_scores = JSON.parse_string(data)
	
