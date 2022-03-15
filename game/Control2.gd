extends Control

export (int) var score = 0

func _physics_process(delta):
	$score.set_text("Packages Delivered : " + str(score))
