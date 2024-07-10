extends RigidBody2D


@onready var label = $Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	label.text = "%s" % sleeping


func _on_timer_timeout():
	freeze = false


func _on_input_event(viewport, event, shape_idx):
	if event.button_mask == 1:
		position = get_global_mouse_position()
