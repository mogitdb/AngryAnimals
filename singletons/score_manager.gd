extends Node

var _level_selected: int = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_level_selected(ls: int) -> void:
	_level_selected = ls
	
	
	
func get_level_selected() -> int:
	return _level_selected
