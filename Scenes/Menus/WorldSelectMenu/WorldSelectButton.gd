extends Button

signal world_select_button_pressed(button)

@export var level_path:String
@export var background_texture:Texture

func _ready():
	$Label.text = text
	text = ""
	
	$Panel/TextureRect.texture = background_texture
	
func _pressed():
	world_select_button_pressed.emit(self)
