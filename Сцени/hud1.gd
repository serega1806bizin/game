extends Control

@onready var ClosedDoor: Area2D = $"../../Interactables/ClosedDoor"


@onready var closed: Control = $ClosedModal

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	ClosedDoor.closed_pressed.connect(_on_closed_pressed)
	closed.closed.connect(_on_any_modal_closed)

func _on_closed_pressed() -> void:
	get_tree().paused = true
	closed.open()

func _on_any_modal_closed() -> void:
	get_tree().paused = false
