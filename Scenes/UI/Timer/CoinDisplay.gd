extends Control

func _process(delta):
	$HBoxContainer/Label.text = str(Global.coins)
