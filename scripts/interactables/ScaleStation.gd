extends Node3D

var current_weight: float = 0.0
var target_weight: float = 0.0
var tolerance: float = 2.0
var active: bool = false
var game: Node = null

func _ready() -> void:
	add_to_group("ScaleStation")
	game = get_tree().get_first_node_in_group("GameRoot")

func start_weigh(data: Dictionary) -> void:
	target_weight = float(data.get("dose_g", 18))
	current_weight = 0.0
	active = true
	_print_label("[b]Objectif : %0.1f g[/b]\nClic = +1 g" % target_weight)

func on_interact() -> void:
	if not active:
		return
	current_weight += 1.0
	_check_weight()

func _check_weight() -> void:
	var diff: float = abs(current_weight - target_weight)
	if diff <= tolerance:
		_print_label("[color=lime]%0.1f g — Parfait ![/color]" % current_weight)
		active = false
		if game:
			game.on_weight_valid()
	elif current_weight > target_weight + tolerance:
		_print_label("[color=orange]%0.1f g — Trop ![/color]" % current_weight)
	else:
		_print_label("%0.1f g…" % current_weight)

func _print_label(text: String) -> void:
	var ui: RichTextLabel = get_tree().get_first_node_in_group("UIRoot")
	if ui:
		ui.text = "[b]Balance[/b]\n%s" % text
