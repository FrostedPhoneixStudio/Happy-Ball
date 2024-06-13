extends CombinedPlatform
class_name CombinedBirdPlatform


func _ready():
	super()
	$AnimationPlayer.play("idle")
	
	
func _on_bird_platform_triggered():
	$CPUParticles2D.emitting = true
