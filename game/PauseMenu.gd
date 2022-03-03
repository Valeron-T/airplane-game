extends Control

var paused = false setget set_pause

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		self.paused = !paused



func set_pause(value):
	paused = value
	get_tree().paused = paused
	visible = paused
	

func _on_Resume_pressed():
	self.paused = false

	
