extends Node2D

@export var texture:Texture

var next_y_position = 0

func _ready():
	$Sprite2D.texture = texture
	$Sprite2D2.texture = texture
	
	$Sprite2D/VisibleOnScreenNotifier2D.rect = Rect2(Vector2.ZERO, get_viewport_rect().size)
	$Sprite2D2/VisibleOnScreenNotifier2D2.rect = Rect2(Vector2.ZERO, get_viewport_rect().size)
	next_y_position -= get_viewport_rect().size.y * 2
	
func move_sprite(sprite):
	sprite.global_position.y = next_y_position
	next_y_position -= get_viewport_rect().size.y


func _on_visible_on_screen_notifier_2d_screen_exited():
	move_sprite($Sprite2D)

func _on_visible_on_screen_notifier_2d_2_screen_exited():
	move_sprite($Sprite2D2)
