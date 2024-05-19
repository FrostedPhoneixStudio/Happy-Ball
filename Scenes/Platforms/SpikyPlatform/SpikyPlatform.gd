extends Platform

class_name SpikyPlatform

# override of the Platform.collide function
func collide(_ball, shape_idx):
	super(_ball, shape_idx)
	_ball.die()

