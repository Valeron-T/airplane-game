extends Spatial

var scene_1 = preload("res://Plane.tscn")
var scene_3 = preload("res://Portal.tscn")

# Number of portals in scene
var portal_count = 0

var world_number = 1

# Initialise coordinates of portal
var portal_spawn_loc = Vector3()


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

func _input(event):
	if event.is_action_pressed("teleport"):
		teleport()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

#function to play teleport animation
func teleport():
	world_number += 1
	$TeleportScreen/AnimationPlayer.play("into_teleport")

#singal function to alert that teleport animation has finished
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "into_teleport":
		emit_signal("teleported")
		$TeleportScreen/AnimationPlayer.play("outof_teleport")
		

func _on_AnimationPlayer_animation_started(anim_name):
	if anim_name == "outof_teleport":
		emit_signal("teleportation_complete")
		if world_number == 2:
			$base_world.visible = not $base_world.visible
			$world2.visible = not $world2.visible
		if world_number == 3:
			$world2.visible = not $world2.visible
			$world3.visible = not $world3.visible
		if world_number == 4:
			$world3.visible = not $world3.visible
			$world4.visible = not $world4.visible
		if world_number % 5 == 0:
			$world4.visible = not $world4.visible
			$base_world.visible = not $base_world.visible
			world_number = 1

func _process(delta):
	# Executes if no portals are already instanced
	if portal_count < 1:
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


func _on_Plane_teleport_now():
	# Decrements portal count as it is deleted
	portal_count -= 1
	teleport()





