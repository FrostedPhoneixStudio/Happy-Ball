extends CanvasLayer


func _on_world_select_button_pressed(button):
	Global.main.change_scene(button.level_path)


func _on_button_pressed():
	Global.main.change_scene("res://Scenes/Menus/MainMenu/MainMenu.tscn")
