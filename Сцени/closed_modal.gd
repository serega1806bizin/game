extends Control

signal closed   # ✅ одно имя везде

@onready var close_btn: Button = $Panel/CloseBtn

func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	close_btn.pressed.connect(close)

func open() -> void:
	visible = true

func close() -> void:
	visible = false
	closed.emit()
