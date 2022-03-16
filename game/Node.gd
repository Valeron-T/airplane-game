extends Node


func _ready():
	$AnimationPlayer.play("GameOver")
	


func _on_Quit_pressed():
	self.queue_free()
	get_tree().change_scene("res://MainMenu.tscn")


func _on_AnimationPlayer_animation_finished(anim_name):
	$ColorRect2.queue_free()
