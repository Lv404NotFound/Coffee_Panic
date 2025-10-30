extends RichTextLabel

func _ready() -> void:
	add_to_group("UIRoot")
	bbcode_enabled = true
	autowrap_mode = TextServer.AUTOWRAP_WORD
	text = "[b]Regardez autour[/b] pour changer de poste.\nCliquez pour interagir."
