extends AudioStreamPlayer

class_name MyAudioStreamPlayer

signal sound_finished

var sound_name:String = ""
var sound_type:String = ""


func fade_out(time:float = 1, stop:bool = true):
	var tween = create_tween()
	tween.tween_property(self, "volume_db", linear_to_db(0.01), time)
	if stop:
		await tween.finished
		stop()
	
func fade_in(to_volume:float, time:float = 1):
	volume_db = -80
	play()
	var tween = create_tween()
	tween.tween_property(self, "volume_db", linear_to_db(to_volume), time)

func _process(delta):
	#print(volume_db)
	pass
