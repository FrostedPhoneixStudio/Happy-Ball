extends CharacterBody2D

class_name Ball

signal died

const GRAVITY = 9.81 * 3

@export var grivity_scale := 1.0 # use this value to scale the gravity of the ball (enemies could use this for example)
@export var jump_force := 1800.0 ## TODO finetune this
var time_scale = 1.0

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

var speed_multiplier = 1.0 # speed up game when achieve every 100 points
var can_speed_up = true

func _ready():
	# initial jump on start of the game
	## TODO maybe this should go into the level class?
	jump()

func _physics_process(delta):
	handle_states()
	handle_animation()
	apply_gravity()
	move(delta)

func move(delta):
	var collision = move_and_collide(velocity * delta * time_scale)
	if collision and collision.get_collider() and state != STATES.GAME_OVER:
		if collision.get_collider() is Platform:
			velocity = Vector2.ZERO
			collision.get_collider().collide(self)

func apply_gravity():
	apply_force(Vector2(0, GRAVITY * time_scale * grivity_scale * speed_multiplier * speed_multiplier))

func apply_force(force:Vector2):
	velocity += force

func jump(jump_force_scale = 1.0):
	velocity.y = -jump_force * jump_force_scale * speed_multiplier

	if state != STATES.GAME_OVER:
		if jump_force_scale <= 1.0:
			state = STATES.NORMAL_JUMP
		else:
			state = STATES.DOUBLE_JUMP

func die():
	if not dead:
		state = STATES.GAME_OVER
		dead = true
		emit_signal("died", self)

		# disable collision when dead
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

func speed_up(points):
	if can_speed_up:
		if points % 100 == 0:
			speed_multiplier = 1.0 + float(points) / 1000
			speed_multiplier = min(speed_multiplier, 2.0)

func _on_visible_on_screen_notifier_2d_screen_exited():
	die()
