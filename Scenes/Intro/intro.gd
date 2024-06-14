extends Node2D


func _on_timer_timeout():
	Global.main.change_scene("res://Scenes/Menus/MainMenu/MainMenu.tscn")
