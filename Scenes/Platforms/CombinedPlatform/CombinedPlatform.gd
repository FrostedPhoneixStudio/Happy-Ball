extends Platform
class_name CombinedPlatform

@export var platforms:Array[Platform]

func _ready():
	for platform in platforms:
		register_platform(platform)
	
func add_platform(platform:Platform):
	platforms.append(platform)
	register_platform(platform)

# this method hands over all the information to the child Platforms in order to work correctly
func register_platform(platform:Platform):
	platform.ball = ball
	platform.collided.connect(on_platform_collided)
	platform.wrap_around = false
	
func on_platform_collided(platform, _ball):
	collide(_ball)
