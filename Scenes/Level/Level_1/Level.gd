extends Node2D

class_name Level


@export var leaderboard_index:int = 0
@export var platform_count_on_screen := 5 # maximum number of platform on screen
@export var coin_spawn_probability := 0.2 # propability of spawning a coin on a platform (for later maybe a curve?)
@export var fruit_spawn_probability := 0.0 # propability of spawning a fruit on a platform (for later maybe a curve?)
@export var spider_spawn_probability := 0.0 # propability of spawning a spider on a platform (for later maybe a curve?)
@export var music_name := ""

@onready var last_platforms_position:Vector2 = $Platforms.global_position # used for platform movement
# used for platform spawning
@onready var next_platform_spawn_y:int = get_viewport_rect().size.y
@onready var platform_spawn_increment:float = get_viewport_rect().size.y / platform_count_on_screen
@onready var timer:Timer = $GameTimer

# platform scene


# weighted list of probabilities of platform spawnes
@export var platform_weights = {
}

var platforms_on_screen:Array[Platform] = [] # array of all platforms currently on screen
var queue_clock_spawn := false

# used for platform movement
var initial_mouse_position 

var points = 0:
	set(value):
		points = value
		$Player.speed_up(points)
		
var fruit_count := 2:
	set(value):
		fruit_count = value
		print(value)


func _ready():
	for i in range(platform_count_on_screen):
		spawn_platform()
	Global.level = self
	if !AudioManager.is_playing(music_name):
		for player in AudioManager.playing_bgm:
			player.fade_out(0.7)
		AudioManager.fade_in(music_name, 0.7)
		
	$Player.died.connect(func (player):
		await get_tree().create_timer(1).timeout
		game_over()
		)

func spawn_platform():
	var ok = false
	var platform:Platform
	while !ok:
		ok = true
		var path_to_platform = Helper.pick_random_from_weighted_list(platform_weights)
		platform = load(path_to_platform).instantiate()
		# if there are two spiky platforms in a row its not ok anymore since the player will die here
		if platform is SpikyPlatform \
			and $Platforms.get_child_count() >=2 \
			and $Platforms.get_child($Platforms.get_child_count()-1) is SpikyPlatform:
				ok = false
	
	platform.ball = $Player
	$Platforms.add_child(platform)
	platform.position.x = randi_range(0, get_viewport_rect().size.x)
	platform.global_position.y = next_platform_spawn_y
	next_platform_spawn_y -= platform_spawn_increment
	platform.screen_exited.connect(on_platform_screen_exited)
	
	# check if a coin or a clock should spawn on the platform
	if platform.can_spawn_collecables:
		if randf_range(0, 1) < coin_spawn_probability:
			var coin = preload("res://Scenes/Collectable/Coins/NormalCoin/NormalCoin.tscn").instantiate()
			platform.add_child(coin)
			coin.global_position = platform.global_position
		elif randf_range(0, 1) < fruit_spawn_probability:
			var fruit = preload("res://Scenes/Collectable/Fruit/Fruit.tscn").instantiate()
			platform.add_child(fruit)
			fruit.global_position = platform.global_position 
		elif randf_range(0, 1) < spider_spawn_probability:
			var spider = preload("res://Scenes/Collectable/Spider/Spider.tscn").instantiate()
			platform.add_child(spider)
			spider.global_position = platform.global_position + Vector2(50,0)
		elif queue_clock_spawn:
			var clock = preload("res://Scenes/Collectable/Clock/Clock.tscn").instantiate()
			platform.add_child(clock)
			queue_clock_spawn = false 


func _physics_process(delta):
	position_platforms()


func position_platforms():
	# if mouse is pressed (later touchscreen) then move platforms
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if !initial_mouse_position:
			initial_mouse_position = get_global_mouse_position()
		$Platforms.global_position.x = get_global_mouse_position().x - initial_mouse_position.x + last_platforms_position.x
	
	# if mouse is not pressed (later touchscreen) then reset some stuff
	if initial_mouse_position and !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		initial_mouse_position = null
		last_platforms_position = $Platforms.global_position


func reset_game_timer():
	timer.wait_time = timer.time_left + 60
	timer.start()
	

func game_over():
	$UI/DeathScreen.open()
	HighscoreManager.save_local_highscore(points, leaderboard_index)
	HighscoreManager.submit_highscore(points, leaderboard_index)
	Global._save()


func on_platform_screen_exited(platform):
	platform.queue_free()
	spawn_platform()


func _on_clock_spawn_timer_timeout():
	queue_clock_spawn = true


func _on_game_timer_timeout():
	$Player.die()

