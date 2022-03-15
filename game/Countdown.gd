extends Control


export (int) var minutes = 0
export (int) var sec = 0
var mlsec = 0

func _physics_process(delta):
	if sec > 0 and mlsec <= 0:
		sec -= 1
		mlsec = 10
	
	if minutes > 0 and sec <= 0:
		minutes -= 1
		sec = 60
	
	if minutes >= 10:
		$minutes.set_text(str(minutes))
	else:
		$minutes.set_text("0" + str(minutes))
	
	if sec >= 10:
		$sec.set_text(str(sec))
	else:
		$sec.set_text("0" + str(sec))

	if mlsec >= 10:
		$mlsec.set_text(str(mlsec))
	else:
		$mlsec.set_text("0" + str(mlsec))


func _on_Timer_timeout():
	mlsec -= 1
