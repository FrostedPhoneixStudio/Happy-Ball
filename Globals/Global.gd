extends Node

const SAVE_FILE_PATH = "user://save.json"

var main:Main
var level:Level

var coins = 0
var points = 0

func _ready():
	if ! FileAccess.file_exists(SAVE_FILE_PATH):
		_save(SAVE_FILE_PATH)
	_load(SAVE_FILE_PATH)

func _exit_tree():
	_save(SAVE_FILE_PATH)

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
