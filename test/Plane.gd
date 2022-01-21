extends KinematicBody

# Airspeed
var flight_speed = 15
# Turn rate
var turn_speed = 0.75
# Climb/dive rate
var pitch_speed = 0.8
# Wings "autolevel" speed
var level_speed = 2.0

# Velocity vector
var velocity = Vector3.ZERO

var turn_input = 0
var pitch_input = 0


func get_input(delta):
	# Turn (roll/yaw) input
	turn_input = 0
	turn_input -= Input.get_action_strength("roll_right")
	turn_input += Input.get_action_strength("roll_left")
	# Pitch (climb/dive) input
	pitch_input = 0
	pitch_input -= Input.get_action_strength("pitch_down")
	pitch_input += Input.get_action_strength("pitch_up")
	
	
func _physics_process(delta):
	# Camera handling
	var camera = get_node("Target/Camera").get_global_transform()
	get_input(delta)
	# Pitch and roll movement
	transform.basis = transform.basis.rotated(transform.basis.x, pitch_input * pitch_speed * delta)
	transform.basis = transform.basis.rotated(Vector3.UP, turn_input * turn_speed * delta)
	# Banking mesh according to roll
	$Mesh/Body.rotation.z = lerp($Mesh/Body.rotation.z, turn_input, level_speed * delta)
	# Velocity and forward movement
	velocity = -transform.basis.z * flight_speed
	velocity = move_and_slide(velocity, Vector3.UP)
	
func _process(delta):
	$Mesh/Body/AnimationPlayer.play("PropAction001")

