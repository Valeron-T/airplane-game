extends Node


func _ready():
	$AnimationPlayer.play("ControlsStart")
	$Timer.start()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	$AnimationPlayer.play("ControlsEnd")
	get_tree().change_scene("res://Universe.tscn")
	self.queue_free()
