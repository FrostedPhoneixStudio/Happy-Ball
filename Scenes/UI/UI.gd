extends CanvasLayer

@onready var death_screen = $DeathScreen

func _ready():
	death_screen.size = get_viewport().get_visible_rect().size
