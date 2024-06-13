extends Collectable

func collect(collector):
	
	var ball:Ball = collector
	if ball.time_scale != 1.0 :
		return
	get_parent().remove_child(self)
	ball.add_child(self)
	position = Vector2(0, -63)
	
	$AnimationPlayer.play("active")
	var tween = create_tween()
	var og_time_scale = ball.time_scale
	tween.tween_property(ball, "time_scale", 0.3, 0.5)
	await get_tree().create_timer(5).timeout
	ball.time_scale = og_time_scale
	queue_free()
	
		
