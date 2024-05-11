extends CenterContainer


var opened = false

func _ready():
	size = get_viewport().get_visible_rect().size


func open():
	opened = true
	get_tree().paused = true
	$AnimationPlayer.play("open")
	
	
func close():
	opened = false
	get_tree().paused = false
	$AnimationPlayer.play("close")
	


func _on_continue_button_pressed():
	close()
	

func _on_restart_button_pressed():
	close()
	Global.main.change_scene(Global.level.scene_file_path)


func _on_main_menu_button_pressed():
	close()
	Global.main.change_scene("res://Scenes/Menus/MainMenu/MainMenu.tscn")

