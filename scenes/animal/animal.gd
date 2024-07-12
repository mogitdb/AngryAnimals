extends RigidBody2D


enum ANIMAL_STATE { READY, DRAG, RELEASE }


const DRAG_LIM_MAX: Vector2 = Vector2(0,60)
const DRAG_LIM_MIN: Vector2 = Vector2(-60, 0)


var _start: Vector2 = Vector2.ZERO
var _drag_start: Vector2 = Vector2.ZERO
var _dragged_vector: Vector2 = Vector2.ZERO
var _last_dragged_vector: Vector2 = Vector2.ZERO


@onready var label = $Label
@onready var stretch_sound = $StretchSound
@onready var arrow = $Arrow


var _state: ANIMAL_STATE = ANIMAL_STATE.READY


# Called when the node enters the scene tree for the first time.
func _ready():
	arrow.hide()
	_start = position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	update(delta)
	label.text = "%s\n" % ANIMAL_STATE.keys()[_state]
	label.text += "%.1f, %.1f" % [_dragged_vector.x, _dragged_vector.y]


func set_new_state(new_state: ANIMAL_STATE) -> void:
	_state = new_state
	if _state == ANIMAL_STATE.RELEASE:
		arrow.hide()
		freeze = false
	elif _state == ANIMAL_STATE.DRAG:
		_drag_start = get_global_mouse_position()
		arrow.show()


func detect_release() -> bool:
	if _state == ANIMAL_STATE.DRAG:
		if Input.is_action_just_released("drag") == true:
			set_new_state(ANIMAL_STATE.RELEASE)
			return true
	return false


func scale_arrow() -> void:
	arrow.rotation = (_start - position).angle()


func play_stretch_sound() -> void:
	if(_last_dragged_vector - _dragged_vector).length() > 0:
		if stretch_sound.playing == false:
			stretch_sound.play()


func get_dragged_vector(gmp: Vector2) -> Vector2:
	return gmp - _drag_start


func drag_in_limits() -> void:
	
	_last_dragged_vector = _dragged_vector
	
	_dragged_vector.x = clampf(
		_dragged_vector.x,
		DRAG_LIM_MIN.x,
		DRAG_LIM_MAX.x
	)
	_dragged_vector.y = clampf(
		_dragged_vector.y,
		DRAG_LIM_MIN.y,
		DRAG_LIM_MAX.y
	)
	position = _start + _dragged_vector
	

func update_drag() -> void:
	
	if detect_release() == true:
		return
	
	var gmp = get_global_mouse_position()
	_dragged_vector = get_dragged_vector(gmp)
	play_stretch_sound()
	drag_in_limits()
	scale_arrow()


func update(delta: float) -> void:
	match _state:
		ANIMAL_STATE.DRAG:
			update_drag()


func die() -> void:
	SignalManager.on_animal_died.emit()
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	die()


func _on_input_event(viewport, event: InputEvent, shape_idx):
	if _state == ANIMAL_STATE.READY and event.is_action_pressed("drag"):
		set_new_state(ANIMAL_STATE.DRAG)
