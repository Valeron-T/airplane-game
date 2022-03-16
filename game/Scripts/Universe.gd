extends Spatial

signal delivery_done

var scene_1 = preload("res://Plane.tscn")
var scene_3 = preload("res://Portal.tscn")
var scene_4 = preload("res://Beacon.tscn")
var hud = preload("res://HUD.tscn")

# Number of portals in scene
var portal_count = 1
var score = 0

# Number of delivery loations in scene
var delivery_loc = 0

var world_number = 1

# Initialise coordinates of portal
var portal_spawn_loc = Vector3()

# Initialise coordinates of delivery location
var delivery_loc_spawn_loc = Vector3()

onready var game_start_time = OS.get_ticks_msec()

#Saves game
func save_game():
	# I/O for save data
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	# Returns nodes which have properties to be saved
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	print(save_nodes)
	# Iterates over nodes in Persist grp to check if it can be saved and if yes, calls the save function 
	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.filename.empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call("save")
		print("Saved Success")

		# Store the save dictionary as a new line in the save file.
		save_game.store_line(to_json(node_data))
	save_game.close()

#Loads saved game
func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return

	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		i.queue_free()

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	save_game.open("user://savegame.save", File.READ)
	while save_game.get_position() < save_game.get_len():
		# Get the saved dictionary from the next line in the save file
		var node_data = parse_json(save_game.get_line())

		# Firstly, we need to create the object and add it to the tree and set its position.
		var new_object = load(node_data["filename"]).instance()
		get_node(node_data["parent"]).add_child(new_object)
		new_object.global_transform.origin = Vector3(node_data["pos_x"],node_data["pos_y"],node_data["pos_z"])

		for i in node_data.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
				continue
			new_object.set(i, node_data[i])

	save_game.close()


#signal to alert that teleport animation has occured
signal teleported
signal teleportation_complete

# Called when the node enters the scene tree for the first time.
func _ready():
	pass	

func deliver():
	$HUD/CanvasLayer/Control2.score += 1
	if portal_count == 1:
		portal_count = 0
	

#function to play teleport animation
func teleport():
	randomize()
	world_number = randi()%4+1
	$TeleportScreen/AnimationPlayer.play("into_teleport")
	

#singal function to alert that teleport animation has finished
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "into_teleport":
		emit_signal("teleported")
		$TeleportScreen/AnimationPlayer.play("outof_teleport")
		

func _on_AnimationPlayer_animation_started(anim_name):
	if anim_name == "outof_teleport":
		$Plane.visible = not $Plane.visible
		emit_signal("teleportation_complete")
		if world_number == 1:
			$base_world.visible = true
			$world2.visible = false
			$world3.visible = false
			$world4.visible = false
			
		if world_number == 2:
			$base_world.visible = false 
			$world2.visible = true
			$world3.visible = false
			$world4.visible = false
			
		if world_number == 3:
			$base_world.visible = false 
			$world2.visible = false
			$world3.visible = true
			$world4.visible = false
	
		if world_number == 4:
			$base_world.visible = false 
			$world2.visible = false
			$world3.visible = false
			$world4.visible = true

		
	
func _process(delta):
	# Executes if no portals are already instanced
	
	if portal_count == 0:
		randomize()
		# Randomize portal coordinates
		portal_spawn_loc.x = rand_range(-200,200)
		portal_spawn_loc.y = rand_range(30,40)
		portal_spawn_loc.z = rand_range(-200,200)
		# Adds portal to main scene
		var portal_scene = preload("res://Portal.tscn").instance()
		portal_scene.set_translation(portal_spawn_loc)
		add_child(portal_scene)
		# Increments active portal count
		portal_count += 1
		
	
	
	# Executes if no delivery loations are already instanced
	if delivery_loc == 0:
		randomize()
		# Randomize delivery loc coordinates
		delivery_loc_spawn_loc.x = rand_range(-200,200)
		delivery_loc_spawn_loc.z = rand_range(-200,200)
		# Adds beacon to main scene
		var delivery_loc_scene = preload("res://Beacon.tscn").instance()
		delivery_loc_scene.set_translation(delivery_loc_spawn_loc)
		add_child(delivery_loc_scene)
		# Increments active beacon count
		delivery_loc += 1


func _on_Plane_teleport_now():
	$Plane.visible = not $Plane.visible
	delivery_loc = 0
	teleport()
	

func _on_Quit_pressed():
	self.queue_free()
	get_tree().change_scene("res://MainMenu.tscn")
	

func _on_Plane_package_deliv():
	deliver()
	$HUD/CanvasLayer/Control.sec += 5


func _on_Control_done():
	self.queue_free()
	get_tree().change_scene("res://GameOver.tscn")
	score = $HUD/CanvasLayer/Control2.score
