extends Control

signal yes_pressed
signal no_pressed

@onready var yes_btn: Button = $YesBtn
@onready var no_btn: Button = $NoBtn

func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	yes_btn.pressed.connect(func(): yes_pressed.emit())
	no_btn.pressed.connect(func(): no_pressed.emit())

func open() -> void:
	visible = true

func close() -> void:
	visible = false
