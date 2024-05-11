extends StaticBody2D

class_name Platform

signal screen_exited(platform)


@export var jump_force_scale = 1.0 # parameter for how heigh the ball should jump on collision
@export var ball:Ball # set this when spawning the platform

var point_counted = false

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



# add here what should happen when the ball collides with the platform
func collide(_ball): ## do we realy need the _ball parameter here? we've got the ball anyway in the ball variable in this class
	_ball.jump(jump_force_scale)
