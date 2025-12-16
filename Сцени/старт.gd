extends Node

# --- ПАНЕЛИ ---
@onready var start_panel = $Panel2/Panel
@onready var form_panel = $Panel2/Форма

# --- ПОЛЯ ФОРМЫ ---
@onready var name_field = $Panel2/Форма/Name
@onready var school_field = $Panel2/Форма/School
@onready var spec_field = $Panel2/Форма/Spec
@onready var contact_label = $Panel2/Форма/Label5
@onready var contact_field = $Panel2/Форма/Contact
@onready var check_info = $Panel2/Форма/CheckButton
@onready var start_game_btn = $Panel2/Форма/"Начать игру"

# --- КНОПКИ НА СТАРТОВОМ ЭКРАНЕ ---
@onready var btn_abit = $Panel2/Panel/Button
@onready var btn_student = $Panel2/Panel/Button2

# 

func _ready() -> void:
	# скрыть форму
	form_panel.visible = false
	contact_label.visible = false
	contact_field.visible = false

	# сигналы
	btn_abit.pressed.connect(_on_abit)
	check_info.toggled.connect(_on_toggle_info)


# --- 1. Открыть форму ---
func _on_abit():
	start_panel.visible = false
	form_panel.visible = true


# --- 2. Чекбокс → показать контакт ---
func _on_toggle_info(checked: bool) -> void:
	contact_label.visible = checked
	contact_field.visible = checked
