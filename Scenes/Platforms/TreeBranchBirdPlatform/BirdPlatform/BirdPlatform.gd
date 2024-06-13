extends Platform

signal triggered

var done = false

func collide(_ball):
	if done:
		_ball.jump(1)
		return
	
	collided.emit(self, _ball)
	if Global.level.fruit_count >= 1:
		Global.level.fruit_count -= 1
		Global.coins += 5
		triggered.emit()
		_ball.jump(1)
		
	else:
		_ball.die()
	done = true
	
