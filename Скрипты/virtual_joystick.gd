extends Control

@onready var outer = $Outer
@onready var inner = $Inner

var dragging := false
var radius := 60
var value := Vector2.ZERO

func get_direction() -> Vector2:
	return value

func _gui_input(event):
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		if event.pressed:
			dragging = true
			_process_drag(event.position)
		elif event is InputEventScreenTouch and not event.pressed:
			dragging = false
			value = Vector2.ZERO
			inner.position = outer.position
	if dragging and event is InputEventScreenDrag:
		_process_drag(event.position)

func _process_drag(pos):
	var center = outer.global_position + outer.size/2
	var dir = pos - center
	var dist = dir.length()

	if dist > radius:
		dir = dir.normalized() * radius

	value = dir / radius
	inner.position = center + dir - inner.size/2
