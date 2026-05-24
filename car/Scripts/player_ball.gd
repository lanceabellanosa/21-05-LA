extends RigidBody3D

@export var speed := 8
@export var max_speed := 15
@export var jump_velocity := 0
@export var camera_speed := 10
@export var air_friction := 1.01
@export var camera_pivot: Node3D
@export var mouse_sensitivity := 0.3

@onready var timer_label: Label = get_tree().root.get_node("World/CanvasLayer/TimerLabel")

var camera: Camera3D
var yaw := 0.0
var spawn_position: Vector3

func _ready():
	Global.elapsed_time = 0.0
	Global.timer_running = true
	spawn_position = global_position
	camera = camera_pivot.get_child(0)
	camera_pivot.top_level = true
	camera_pivot.global_position = global_position
	camera_pivot.rotation = Vector3.ZERO
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	yaw = 0.0
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("floor"):
		respawn()

func respawn():
	global_position = spawn_position
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO
	Global.elapsed_time = 0.0

func _input(event):
	if event is InputEventMouseMotion:
		yaw -= event.relative.x * mouse_sensitivity * 0.01

func _physics_process(delta: float):
	if Global.timer_running:
		Global.elapsed_time += delta
		timer_label.text = "Time Elapsed: %.2f" % Global.elapsed_time

	var forward = -camera_pivot.global_transform.basis.z
	var right = camera_pivot.global_transform.basis.x
	forward.y = 0
	right.y = 0
	forward = forward.normalized()
	right = right.normalized()

	var move = Input.get_axis("s", "w") * forward + Input.get_axis("a", "d") * right
	angular_velocity += speed * delta * Vector3(move.x, 0, move.z)
	linear_velocity.x += move.x * speed * delta
	linear_velocity.z += move.z * speed * delta

	var horizontal = Vector3(linear_velocity.x, 0, linear_velocity.z)
	if horizontal.length() > max_speed:
		horizontal = horizontal.normalized() * max_speed
		linear_velocity = Vector3(horizontal.x, linear_velocity.y, horizontal.z)

	if Input.is_action_just_pressed("ui_accept"): linear_velocity.y += jump_velocity
	angular_velocity /= air_friction

func _process(delta: float):
	camera_pivot.transform.basis = Basis.from_euler(Vector3(-0.4, yaw, 0), EULER_ORDER_YXZ)
	camera_pivot.global_position = camera_pivot.global_position.lerp(
		global_position,
		camera_speed * delta
	)
