extends Node

enum State { WAITING, WEIGHING, BREWING, SERVING, SCORE }

var current_zone: String = "center"
var state: State = State.WAITING
var recipe: Dictionary = {}
var scale_station: Node = null
var machine_station: Node = null
var serve_station: Node = null
var score: int = 0

func _ready() -> void:
	add_to_group("GameRoot")
	print("Game ready.")
	recipe = Recipes.get_random()
	scale_station = get_tree().get_first_node_in_group("ScaleStation")
	machine_station = get_tree().get_first_node_in_group("MachineStation")
	serve_station = get_tree().get_first_node_in_group("ServeStation")
	_update_ui("[b]Regardez la balance[/b] pour commencer à peser.")

func on_zone_changed(zone: String) -> void:
	if zone == current_zone:
		return
	current_zone = zone
	match zone:
		"center": _on_focus_center()
		"left": _on_focus_left()
		"right": _on_focus_right()

func _on_focus_center() -> void:
	match state:
		State.WAITING:
			state = State.WEIGHING
			scale_station.start_weigh(recipe)
			_update_ui("[b]Pesée[/b]\nCliquez pour ajouter du café.")
		State.SCORE:
			_new_round()

func _on_focus_left() -> void:
	if state == State.BREWING:
		machine_station.start_brew(recipe)
		_update_ui("[b]Extraction[/b]\nClic pour démarrer la machine.")

func _on_focus_right() -> void:
	if state == State.SERVING:
		serve_station.serve(recipe, score)
		state = State.SCORE
		_update_ui("[b]Service terminé[/b]\nScore : %d\nRegardez la balance pour recommencer." % score)

func on_weight_valid() -> void:
	state = State.BREWING
	_update_ui("[b]Pesée correcte ![/b]\nRegardez la machine à gauche.")

func on_brew_complete(success: bool) -> void:
	if success:
		score += 10
		_update_ui("[b]Extraction réussie ![/b]\nRegardez le comptoir à droite.")
	else:
		score += 5
		_update_ui("[b]Extraction ratée…[/b]\nRegardez le comptoir à droite.")
	state = State.SERVING

func _update_ui(msg: String) -> void:
	var ui: RichTextLabel = get_tree().get_first_node_in_group("UIRoot")
	if ui:
		ui.text = msg

func _new_round() -> void:
	state = State.WAITING
	recipe = Recipes.get_random()
	score = 0
	_update_ui("[b]Nouvelle commande ![/b]\nRegardez la balance pour commencer.")
