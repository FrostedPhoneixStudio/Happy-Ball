extends Platform
class_name NormalPlatform


func collide(_ball):
	_ball.jump(jump_force_scale)
	collided.emit(_ball, self)
