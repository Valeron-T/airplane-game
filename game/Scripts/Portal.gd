extends Spatial

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start()
	pass # Replace with function body.


# Deletes portal after x secs (100 as of now)
func _on_Timer_timeout():
	queue_free()



