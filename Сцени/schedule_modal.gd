extends Control

signal closed
@export var schedule_texture: Texture2D

@onready var close_btn: Button = $Panel/CloseBtn
@onready var panel: Panel = $Panel


func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	close_btn.pressed.connect(close)

func open() -> void:
	visible = true

func close() -> void:
	visible = false
	closed.emit()
