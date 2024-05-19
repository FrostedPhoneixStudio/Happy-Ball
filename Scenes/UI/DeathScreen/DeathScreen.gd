extends CenterContainer


func _ready():
	size = get_viewport().get_visible_rect().size
	#get_tree().paused = true

func _on_restart_button_pressed():
	$AnimationPlayer.play("close")
	Global.main.change_scene(Global.level.scene_file_path)


func _on_main_menu_button_pressed():
	$AnimationPlayer.play("close")
	Global.main.change_scene("res://Scenes/Menus/MainMenu/MainMenu.tscn")


func open():
	$AnimationPlayer.play("open")


func close():
	$AnimationPlayer.play("close")


#func _exit_tree():
	#get_tree().paused = false
