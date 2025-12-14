extends Area2D

signal closed_pressed

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	input_pickable = true

func _input_event(_viewport, event, _shape_idx) -> void:
	if event is InputEventMouseButton \
	and event.pressed \
	and event.button_index == MOUSE_BUTTON_LEFT:
		closed_pressed.emit()

	if event is InputEventScreenTouch and event.pressed:
		closed_pressed.emit()
