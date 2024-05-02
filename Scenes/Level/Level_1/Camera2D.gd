extends Camera2D

@export var target:Node2D

var min_global_y_position:int


func _ready():
	if is_instance_valid(target):
		min_global_y_position = target.global_position.y
		
func _physics_process(delta):
	if is_instance_valid(target):
		if target is Ball:
			global_position = target.global_position - Vector2(0, target.height / 2)
			if global_position.y > min_global_y_position:
				global_position.y = min_global_y_position
			else:
				min_global_y_position = global_position.y
