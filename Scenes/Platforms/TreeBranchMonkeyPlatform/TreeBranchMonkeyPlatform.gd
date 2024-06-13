extends CombinedPlatform
class_name CombinedMonkeyPlatform


func _ready():
	super()
	$AnimationPlayer.play("idle")


func _on_monkey_platform_thrown():
	$AnimationPlayer.play("throw")
