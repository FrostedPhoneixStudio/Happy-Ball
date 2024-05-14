extends Node

var main:Main
var level:Level

var coins = 0
var points = 0

var save_path = OS.get_user_data_dir() + "save.json"

func _ready():
	_load(save_path)

func _exit_tree():
	_save(save_path)

func _save(path):
	var data = {
		"coins" = coins,
		"points" = points
	}
	
	# send data to json file
	var json_string = JSON.stringify(data, "\t")
	var file = FileAccess.open(path,FileAccess.WRITE)
	file.store_string(json_string)
	file.close()

func _load(path):
	# Read json file
	var file = FileAccess.open(path,FileAccess.READ)
	if file != null:
		var save_data = JSON.parse_string(file.get_as_text())
		coins = save_data["coins"]
		points = save_data["points"]
