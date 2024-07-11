extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	pass

func die() -> void:
	SignalManager.on_animal_died.emit()
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	die()
