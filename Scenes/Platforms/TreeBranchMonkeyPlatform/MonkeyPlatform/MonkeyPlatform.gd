extends Platform
class_name MonkeyPlatform
signal thrown()


func collide(_ball):
	collided.emit(self, _ball)
	if Global.level.fruit_count >= 1:
		Global.level.fruit_count -= 1
		_ball.jump(2)
		thrown.emit()
	else:
		_ball.jump(1)
