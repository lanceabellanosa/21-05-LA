extends Area3D

@export var launch_force := 22

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body is RigidBody3D:
		body.linear_velocity.y = launch_force
