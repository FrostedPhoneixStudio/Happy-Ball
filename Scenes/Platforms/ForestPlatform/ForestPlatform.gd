extends Platform

class_name ForestPlatform


func _physics_process(delta):
	# make the platform collidable with the ball only if the ball is above it
	if ball:
		if ball.global_position.y < global_position.y and !get_collision_layer_value(1):
			set_collision_layer_value(1, true)
			if !point_counted:
				Global.level.points += 5
				point_counted = true
		
		if ball.global_position.y - (ball.height / 2) > global_position.y and get_collision_layer_value(1):
			set_collision_layer_value(1, false)


	# check if platform exited screen (really just the bottom of the screen)
	var game_y = get_viewport().get_camera_2d().global_position.y
	if global_position.y > game_y + get_viewport_rect().size.y / 2:
		screen_exited.emit(self)
		
	# check if the platform exited the screed on the side and reposition it
	var game_rect:Rect2 = get_viewport_rect()
	var platform_rect:Rect2 = Rect2(global_position, $CollisionLeft.shape.size) #CAUTION! this only works if the shape is a RecrtangleShape2D!

	if global_position.x - platform_rect.size.x > game_rect.size.x:
		# exit on the right
		global_position.x = 0 - platform_rect.size.x

	if global_position.x + platform_rect.size.x < 0:
		# exit on the left
		global_position.x = game_rect.size.x + platform_rect.size.x

func collide(_ball, shape_idx): ## do we realy need the _ball parameter here? we've got the ball anyway in the ball variable in this class
	if shape_idx != 2:
		_ball.jump(jump_force_scale)
	else: 
		super(_ball, shape_idx)
		_ball.die()
