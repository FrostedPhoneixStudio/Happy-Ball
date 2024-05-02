extends Collectable

func collect(collector):
	Global.level.reset_game_timer()
	queue_free()
