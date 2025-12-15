extends Control

signal choice_selected(id)

@onready var label_text: Label = $Panel/LabelText
@onready var btn1: Button = $Panel/Btn1
@onready var btn2: Button = $Panel/Btn2
@onready var btn3: Button = $Panel/Btn3
@onready var btn4: Button = $Panel/Btn4   # ← правильный путь!

func _ready():
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS

	btn1.pressed.connect(func(): _on_button_pressed(1))
	btn2.pressed.connect(func(): _on_button_pressed(2))
	btn3.pressed.connect(func(): _on_button_pressed(3))
	btn4.pressed.connect(func(): _on_button_pressed(4))

func open_dialog(text: String, choices: Array):
	visible = true
	get_tree().paused = true
	label_text.text = text

	var buttons = [btn1, btn2, btn3, btn4]

	# спрятать все
	for b in buttons:
		b.visible = false

	# включить нужные
	for i in range(min(choices.size(), buttons.size())):
		buttons[i].text = choices[i]
		buttons[i].visible = true

func close_dialog():
	visible = false
	get_tree().paused = false

func _on_button_pressed(id: int):
	close_dialog()
	choice_selected.emit(id)
