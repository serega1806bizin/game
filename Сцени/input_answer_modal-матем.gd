extends Control

signal answer_submitted(value)

@onready var label_task: Label = $Panel/LabelTask
@onready var input_field: LineEdit = $Panel/InputField
@onready var btn: Button = $Panel/BtnConfirm

func _ready():
	visible = false
	btn.pressed.connect(_on_confirm)

func open_task(text: String):
	visible = true
	get_tree().paused = true
	input_field.text = ""
	label_task.text = text
	input_field.grab_focus()

func close_task():
	visible = false
	get_tree().paused = false

func _on_confirm():
	var v = input_field.text.strip_edges()
	answer_submitted.emit(v)
	close_task()
