extends Area3D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body is RigidBody3D:
		Global.timer_running = false
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/title screen.tscn")
