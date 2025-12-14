extends Control

signal closed

@onready var close_btn: Button = $Panel/CloseBtn
@onready var label1: Label = $Panel/Label
@onready var label2: Label = $Panel/Label2

@onready var panel: Panel = $Panel



func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	close_btn.pressed.connect(close)

func open(r: String) -> void:
	visible = true
	if (r == "g"):
		label1.visible = true
		label2.visible = true
	if (r == "t"):
		label1.visible = false
		label2.visible = false


func close() -> void:
	visible = false
	closed.emit()
