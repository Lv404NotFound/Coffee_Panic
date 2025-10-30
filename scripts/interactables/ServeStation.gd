extends Node3D

func _ready() -> void:
	add_to_group("ServeStation") # ✅ déplacé ici

func serve(data: Dictionary, score: int) -> void:
	var ui: RichTextLabel = get_tree().get_first_node_in_group("UIRoot")
	if ui:
		ui.text = "[b]Service terminé[/b]\n%s prêt !\nScore : %d" % [data.get("display_name", "Café"), score]
