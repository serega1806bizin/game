extends Area2D

signal shop_pressed

func _input_event(viewport, event, shape_idx) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		shop_pressed.emit()
