extends Collectable

func collect(collector):
	Global.coins += 1
	queue_free()
