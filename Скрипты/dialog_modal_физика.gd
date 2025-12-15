extends Control

@onready var label_text = $Panel/LabelText
@onready var btns = [
	$Panel/Btn1,
	$Panel/Btn2,
	$Panel/Btn3,
	$Panel/Btn4
]

var _callbacks: Array = []


func _ready() -> void:
	# подключаем все кнопки к _press
	for i in range(btns.size()):
		var idx := i   # фиксируем индекс, чтобы замыкание не глючило
		btns[i].pressed.connect(func(): _press(idx))


func show_modal(text: String, choices: Array) -> void:
	visible = true
	label_text.text = text

	# спрятать все кнопки
	for b in btns:
		b.visible = false

	_callbacks.clear()

	# включить нужные (максимум 4)
	for i in range(min(choices.size(), btns.size())):
		btns[i].visible = true
		btns[i].text = choices[i]["label"]
		_callbacks.append(choices[i]["callback"])


func _press(idx: int) -> void:
	visible = false
	if idx < _callbacks.size():
		_callbacks[idx].call()
