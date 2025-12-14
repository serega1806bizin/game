extends Control

@onready var ToiletDoor: Area2D = $"../../Interactables/ToiletDoor"
@onready var ClosedDoor: Area2D = $"../../Interactables/ClosedDoor"

@onready var toilet: Control = $ToiletModal
@onready var closed: Control = $ClosedModal

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	ToiletDoor.toilet_pressed.connect(_on_toilet_pressed)
	ClosedDoor.closed_pressed.connect(_on_closed_pressed)

	toilet.closed.connect(_on_any_modal_closed)
	closed.closed.connect(_on_any_modal_closed)

func _on_toilet_pressed() -> void:
	get_tree().paused = true
	toilet.open()

func _on_closed_pressed() -> void:
	get_tree().paused = true
	closed.open()

func _on_any_modal_closed() -> void:
	get_tree().paused = false
