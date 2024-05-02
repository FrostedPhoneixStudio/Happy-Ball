extends Collectable

func collect(collector):
	Global.coins += 1
	print(Global.coins)
	queue_free()
