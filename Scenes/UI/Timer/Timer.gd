extends Control

func _process(delta):
	$HBoxContainer/Seconds.text = str(int(Global.level.timer.time_left))
