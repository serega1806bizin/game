extends Control

@onready var label_text = $Panel/LabelText
@onready var code_input = $Panel/CodeInput

@onready var btns = [
	$Panel/Btn1,
	$Panel/Btn2,
	$Panel/Btn3,
	$Panel/Btn4
]

var _callbacks: Array = []
var _use_input := false


func _ready():
	for i in range(btns.size()):
		var idx := i
		btns[i].pressed.connect(func(): _on_press(idx))
	visible = false   # старт вимкнений


func show_modal(text: String, choices: Array, use_input := false):
	visible = true
	label_text.text = text

	_use_input = use_input
	code_input.visible = use_input

	if use_input:
		code_input.text = ""
		code_input.grab_focus()

	# ховаємо кнопки
	for b in btns:
		b.visible = false

	_callbacks.clear()

	# виводь потрібні кнопки
	for i in range(min(choices.size(), btns.size())):
		btns[i].visible = true
		btns[i].text = choices[i]["label"]
		_callbacks.append(choices[i]["callback"])


func _on_press(idx):
	visible = false

	if idx < _callbacks.size():
		if _use_input:
			_callbacks[idx].call(code_input.text)
		else:
			_callbacks[idx].call()
