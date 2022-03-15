extends KinematicBody

signal teleport_now

var teleport_complete = 0
# Airspeed
var flight_speed = 30
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

var location_x = 0
var location_y = 0
var location_z = 0
var rotation_x = 0
var rotation_y = 0
var rotation_z = 0

# Creates a dictionary to store custom data from object
func save():
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"pos_x" : location_x,
		"pos_y" : location_y,
		"pos_z" : location_z,
		"rot_x" : rotation_x,
		"rot_y" : rotation_y,
		"rot_z" : rotation_z
	}
	return save_dict
	
func get_input(delta):
	# Turn (roll/yaw) input
	turn_input = 0
	turn_input -= Input.get_action_strength("roll_right")
	turn_input += Input.get_action_strength("roll_left")
	# Pitch (climb/dive) input
	pitch_input = 0
	pitch_input -= Input.get_action_strength("pitch_down")
	pitch_input += Input.get_action_strength("pitch_up")
	
func _ready():
	pass
	
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
	queue_teleport()
	
	
	
func queue_teleport():
	var slide_count = get_slide_count()
	if slide_count:
		var collision = get_slide_collision(slide_count - 1)
		var collider = collision.collider
		if collider.name == 'PortalBody':
			emit_signal('teleport_now')
			collider.queue_free()
		
		if collider.name == 'Beaconbody':
			emit_signal('package_deliv')
			collider.queue_free()
	
func _process(delta):
	# Properller animation5
	$Mesh/Body/AnimationPlayer.play("PropAction001")
	# Updates location and direction of plane
	location_x = $Mesh.global_transform.origin.x
	location_y = $Mesh.global_transform.origin.y
	location_z = $Mesh.global_transform.origin.z
	rotation_x = rad2deg($Mesh.global_transform.basis.get_euler().x)
	rotation_y = rad2deg($Mesh.global_transform.basis.get_euler().y)
	rotation_z = rad2deg($Mesh.global_transform.basis.get_euler().z)
	# Debug code
	# print(location_x, " ", location_y, " ", location_z)
	
	
