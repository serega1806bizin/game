extends Control

@onready var panel = $Panel
@onready var label = $Panel/Label
@onready var btn1 = $Panel/Btn1
@onready var btn2 = $Panel/Btn2
@onready var btn3 = $Panel/Btn3

var _callbacks = []


func _ready():
	mouse_filter = Control.MOUSE_FILTER_STOP
	panel.mouse_filter = Control.MOUSE_FILTER_STOP

	btn1.pressed.connect(func(): _press(0))
	btn2.pressed.connect(func(): _press(1))
	btn3.pressed.connect(func(): _press(2))

	visible = false


func show_modal(text, choices):
	visible = true
	label.text = text

	var btns = [btn1, btn2, btn3]
	_callbacks.clear()

	for b in btns:
		b.visible = false

	for i in choices.size():
		btns[i].visible = true
		btns[i].text = choices[i]["label"]
		_callbacks.append(choices[i]["callback"])


func _press(idx):
	visible = false
	if idx < _callbacks.size():
		_callbacks[idx].call()
