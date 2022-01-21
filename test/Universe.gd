extends Spatial

#signal to alert that teleport animation has occured
signal teleported
signal teleportation_complete

func _input(event):
	if event.is_action_pressed("teleport"):
		teleport()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#function to play teleport animation
func teleport():
	$TeleportScreen/AnimationPlayer.play("into_teleport")

#singal function to alert that teleport animation has finished
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "into_teleport":
		emit_signal("teleported")
		$TeleportScreen/AnimationPlayer.play("outof_teleport")
		

func _on_AnimationPlayer_animation_started(anim_name):
	if anim_name == "outof_teleport":
		emit_signal("teleportation_complete")
		$base_world.visible = not $base_world.visible
		$world2.visible = not $world2.visible
