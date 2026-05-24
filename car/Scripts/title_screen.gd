extends Control

@onready var time_label: Label = $TimeLabel

func _ready():
	if Global.elapsed_time > 0:
		time_label.text = "Last Run: %.2f seconds" % Global.elapsed_time
	else:
		time_label.text = ""

func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/World.tscn")
