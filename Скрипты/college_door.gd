extends Area2D

@export var next_scene: String = "res://Сцени/хол.tscn"

func _ready() -> void:
	input_pickable = true

func _input_event(viewport, event, shape_idx) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_go()

	# на мобилке тоже приходит как MouseButton, но оставим ещё на всякий случай:
	if event is InputEventScreenTouch and event.pressed:
		_go()

func _go() -> void:
	# если у тебя игра могла быть на паузе из-за модалок — снимем паузу перед переходом
	get_tree().paused = false

	var err := get_tree().change_scene_to_file(next_scene)
	if err != OK:
		push_error("Не могу открыть сцену: " + next_scene + " (err=" + str(err) + ")")
