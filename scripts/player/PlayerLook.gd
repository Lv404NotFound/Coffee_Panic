extends Camera3D

@export var sensitivity := 0.15
@export var max_yaw := 90.0
@export var max_pitch := 35.0
@export var gaze_switch_time := 3.0  # temps pour changer de poste

var _yaw := 0.0
var _pitch := 0.0
var _gaze_timer := 0.0
var _current_zone := "center"

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_yaw -= event.relative.x * sensitivity
		_pitch -= event.relative.y * sensitivity
		_pitch = clamp(_pitch, -max_pitch, max_pitch)
		_yaw = clamp(_yaw, -max_yaw, max_yaw)
		rotation_degrees = Vector3(_pitch, _yaw, 0)

func _process(delta: float) -> void:
	var zone := _detect_zone()
	if zone == _current_zone:
		_gaze_timer += delta
	else:
		_gaze_timer = 0.0
		_current_zone = zone

	if _gaze_timer >= gaze_switch_time:
		_gaze_timer = 0.0
		emit_signal_to_game(zone)

func _detect_zone() -> String:
	if _yaw < -45: return "left"
	elif _yaw > 45: return "right"
	else: return "center"

func emit_signal_to_game(zone: String) -> void:
	var game := get_tree().get_first_node_in_group("GameRoot")
	if game and game.has_method("on_zone_changed"):
		game.on_zone_changed(zone)
