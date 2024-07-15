extends Node


var _attempts: int = 0
var _cups_hit: int = 0
var _total_cups: int = 0
var _level_number: int = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	_total_cups = get_tree().get_nodes_in_group("cup").size()
	_level_number = ScoreManager.get_level_selected()
	SignalManager.on_attempt_made.connect(on_attempt_made)
	SignalManager.on_cup_destroyed.connect(on_cup_destroyed)


func on_attempt_made() -> void:
	_attempts += 1
	SignalManager.on_score_updated.emit(_attempts)


func on_cup_destroyed() -> void:
	_cups_hit += 1
	if _cups_hit == _total_cups:
		SignalManager.on_level_complete.emit()
		ScoreManager.set_score_for_level(_attempts, str(_level_number))

