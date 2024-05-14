extends Node

const SAVE_FILE_PATH = "user://save.json"

var main:Main
var level:Level

var coins = 0

func _ready():
	if ! FileAccess.file_exists(SAVE_FILE_PATH):
		_save()
	_load(SAVE_FILE_PATH)

func _exit_tree():
	_save()

func _save():
	var data = {
		"coins" = coins,
	}
	
	# send data to json file
	var json_string = JSON.stringify(data, "\t")
	var file = FileAccess.open(SAVE_FILE_PATH,FileAccess.WRITE)
	file.store_string(json_string)
	file.close()

func _load(path):
	# Read json file
	var file = FileAccess.open(path,FileAccess.READ)
	if FileAccess.file_exists(SAVE_FILE_PATH):
		var save_data = JSON.parse_string(file.get_as_text())
		coins = save_data["coins"]
