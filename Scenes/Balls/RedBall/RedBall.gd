# Baseclass for Balls
# including fucntions for movement, jumping, and animation
##TODO maybe the special abilities could be child nodes we add? or we inherit from this class and add the functionality
## this way
extends CharacterBody2D

class_name Ball

signal died

const GRAVITY = 9.81 * 3

@export var grivity_scale := 1.0 # use this value to scale the gravity of the ball (enemies could use this for example)
@export var jump_force := 1800.0 ## TODO finetune this

@onready var height = $Sprite2D.texture.get_height() * scale.y # the height of the ball TODO add width too

enum STATES {
	NEUTRAL,
	NORMAL_JUMP,
	DOUBLE_JUMP,
	POWER_MODE,
	GAME_OVER
}

var dead := false
var state = STATES.NEUTRAL

var speed_multiplicator = 1.0 # speed up game when achive every 100 points

func _ready():
	# initial jump on start of the game
	## TODO maybe this should go into the levle class?
	jump()

func _physics_process(delta):
	handle_states()
	handle_animation()
	apply_gravity()
	speed_up_game(Global.points)
	move(delta)


func move(delta):
	var collision = move_and_collide(velocity * delta)
	if collision and collision.get_collider() and state != STATES.GAME_OVER:
		if collision.get_collider() is Platform:
			velocity = Vector2.ZERO
			collision.get_collider().collide(self)
			
	
func apply_gravity():
	apply_force(Vector2(0, GRAVITY * grivity_scale))

func apply_force(force:Vector2):
	velocity += force

func jump(jump_force_scale = 1.0):
	velocity = Vector2.ZERO
	apply_force(Vector2(0, -jump_force * jump_force_scale * speed_multiplicator))
	
	if state != STATES.GAME_OVER:
		if jump_force_scale <= 1.0:
			state = STATES.NORMAL_JUMP
		else:
			state = STATES.DOUBLE_JUMP


func die():
	if !dead:
		state = STATES.GAME_OVER
		dead = true
		emit_signal("died", self)
		
		# disable collision whe dead
		set_collision_layer_value(1, false)
		set_collision_mask_value(1, false)


func handle_states():
	if state != STATES.GAME_OVER and state != STATES.POWER_MODE:
		if velocity.y > 0:
			state = STATES.NEUTRAL


func handle_animation():
	match state:
		STATES.NEUTRAL:
			$Sprite2D.frame = 2
		STATES.NORMAL_JUMP:
			$Sprite2D.frame = 1
		STATES.DOUBLE_JUMP:
			$Sprite2D.frame = 0
		STATES.POWER_MODE:
			$Sprite2D.frame = 4
		STATES.GAME_OVER:
			$Sprite2D.frame = 3


func speed_up_game(points):
	speed_multiplicator = 1 + points/1000
	if speed_multiplicator > 2:
		speed_multiplicator = 2
	grivity_scale = speed_multiplicator * speed_multiplicator


func _on_visible_on_screen_notifier_2d_screen_exited():
	die()
