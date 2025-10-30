extends RayCast3D
signal interact(target: Node)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		if is_colliding():
			var target = get_collider()
			if target and target.has_method("on_interact"):
				target.on_interact()
				interact.emit(target)
