# Base class for collectables
extends Node2D

class_name Collectable

@onready var area:Area2D = $Area2D


func _ready():
	area.body_entered.connect(func(body):
		if body is Ball:
			collect(body)
		)

# override this function with whatever the collectable should do on collect
func collect(collector):
	pass
