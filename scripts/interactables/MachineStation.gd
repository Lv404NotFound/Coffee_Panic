extends Node3D

var brewing: bool = false
var game: Node = null

func _ready() -> void:
	add_to_group("MachineStation") # ✅ déplacé ici
	game = get_tree().get_first_node_in_group("GameRoot")

func start_brew(data: Dictionary) -> void:
	if brewing:
		return
	_print("[b]Machine[/b]\nCliquez pour lancer l’extraction.")
	brewing = true

func on_interact() -> void:
	if brewing:
		brewing = false
		_start_timer()

func _start_timer() -> void:
	_print("[b]Extraction en cours...[/b]")
	var t := Timer.new()
	t.wait_time = 5.0
	t.one_shot = true
	add_child(t)
	t.start()
	t.timeout.connect(func():
		if game:
			game.on_brew_complete(true)
		queue_free())

func _print(msg: String) -> void:
	var ui: RichTextLabel = get_tree().get_first_node_in_group("UIRoot")
	if ui:
		ui.text = msg
