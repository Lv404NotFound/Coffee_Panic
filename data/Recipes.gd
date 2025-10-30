extends Node
class_name Recipes

const LIST := {
	"espresso": {"display_name": "Espresso", "dose_g": 18},
	"lungo": {"display_name": "Lungo", "dose_g": 20},
	"cappuccino": {"display_name": "Cappuccino", "dose_g": 16}
}

static func get_random() -> Dictionary:
	var keys = LIST.keys()
	return LIST[keys[randi() % keys.size()]]
