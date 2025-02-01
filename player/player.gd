extends RigidBody3D
#variables declared
var mouse_sensitivity := 0.001
var twist_input := 0.0
var pitch_input := 0.0

@onready var twist_pivot:= $TwistPivot
@onready var pitch_pivot:= $TwistPivot/PitchPivot

#on ready function 
func _ready() -> void:
	#mouse capturing code
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	

#process  function
func _process(delta: float) -> void:
	#movement control keybord
	var input := Vector3.ZERO
	input.x = Input.get_axis("move_left","move_right")
	input.z = Input.get_axis("move_front","move_back")
	
	apply_central_force(twist_pivot.basis * input *  1200.0 * delta)
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	#camera control 
	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, deg_to_rad(-30), deg_to_rad(30))
	
	twist_input = 0.0
	pitch_input = 0.0
#unhandled input function
func _unhandled_input(event: InputEvent) -> void:
	#mouse movement input gathering 
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = - event.relative.x * mouse_sensitivity
			pitch_input = - event.relative.y * mouse_sensitivity
