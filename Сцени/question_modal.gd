extends Control

signal curator_pressed
signal group_pressed
signal schedule_pressed
signal closed

@onready var close_btn: Button = $Panel/CloseBtn
@onready var btn_curator: Button = $Panel/BtnCurator
@onready var btn_group: Button = $Panel/BtnGroup
@onready var btn_schedule: Button = $Panel/BtnSchedule

func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	close_btn.pressed.connect(_on_close_pressed)
	btn_curator.pressed.connect(func(): curator_pressed.emit())
	btn_group.pressed.connect(func(): group_pressed.emit())
	btn_schedule.pressed.connect(func(): schedule_pressed.emit())

func open() -> void:
	visible = true

func close() -> void:
	visible = false
	closed.emit()

func _on_close_pressed() -> void:
	close()
