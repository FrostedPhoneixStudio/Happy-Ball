extends CanvasLayer

@onready var death_screen = $DeathScreen


func _on_pause_button_pressed():
	if !$PauseScreen.opened:
		$PauseScreen.open()
	else:
		$PauseScreen.close()
