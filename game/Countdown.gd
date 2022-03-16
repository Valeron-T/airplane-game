extends Control

signal done
export (int) var sec = 60
var timer_count = 0

func _physics_process(delta):
	$sec.set_text(str(sec))
	
	if sec == 0:
		emit_signal("done")
		
func _on_Timer2_timeout():
	sec -= 1
