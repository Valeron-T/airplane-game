extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_PlayButton_pressed():
	get_tree().change_scene("res://Universe.tscn")
	self.queue_free()
