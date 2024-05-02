extends Platform

class_name SpikyPlatform

# override of the Platform.collide function
func collide(_ball):
	super(_ball)
	_ball.die()

