extends Area2D

@export var target_scene: String

func _ready() -> void:
	input_pickable = true

func _input_event(viewport, event, shape_idx) -> void:
	if event is InputEventMouseButton \
	and event.pressed \
	and event.button_index == MOUSE_BUTTON_LEFT:
		_go_to_scene()

func _go_to_scene() -> void:
	if target_scene == "":
		push_warning("Не указана target_scene у стрелки!")
		return

	get_tree().paused = false
	get_tree().change_scene_to_file(target_scene)
