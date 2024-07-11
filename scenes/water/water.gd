extends Area2D


@onready var splash = $Splash


func _on_body_entered(body):
	splash.play()
