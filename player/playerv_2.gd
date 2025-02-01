extends CharacterBody3D

var mouse_sensitivity := 0.001
var twist_input := 0.0
var pitch_input := 0.0

@onready var twist_pivot := $TwistPivot
@onready var pitch_pivot := $TwistPivot/PitchPivot

const SPEED: float = 5.0
const JUMP_VELOCITY: float = 4.5

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	# Add gravity
	if not is_on_floor():
		velocity.y -= 9.8 * delta  # Default Godot gravity

	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Camera movement
	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, deg_to_rad(-30), deg_to_rad(30))
	twist_input = 0.0
	pitch_input = 0.0

	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	# Handle movement
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_front", "move_back")
	var direction: Vector3 = (twist_pivot.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction.length() > 0:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	# Mouse movement tracking
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = -event.relative.x * mouse_sensitivity
			pitch_input = -event.relative.y * mouse_sensitivity
