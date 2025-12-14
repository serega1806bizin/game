extends Control

signal choice_selected(id)

@onready var portrait: TextureRect = $Panel/Portrait
@onready var label_text: Label = $Panel/LabelText
@onready var btn1: Button = $Panel/Btn1
@onready var btn2: Button = $Panel/Btn2
@onready var btn3: Button = $Panel/Btn3

func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS

	btn1.pressed.connect(func(): _on_button_pressed(1))
	btn2.pressed.connect(func(): _on_button_pressed(2))
	btn3.pressed.connect(func(): _on_button_pressed(3))

func open_dialog(character_texture: Texture2D, text: String, choices: Array) -> void:
	visible = true
	get_tree().paused = true

	portrait.texture = character_texture
	label_text.text = text

	# Скрыть кнопки
	btn1.visible = false
	btn2.visible = false
	btn3.visible = false

	# Показать нужные
	for i in choices.size():
		var btn = [btn1, btn2, btn3][i]
		btn.text = choices[i]
		btn.visible = true

func close_dialog():
	visible = false
	get_tree().paused = false

func _on_button_pressed(id: int):
	close_dialog()
	choice_selected.emit(id)
