extends Collectable

func collect(collector):
	Global.level.fruit_count += 1
	queue_free()
