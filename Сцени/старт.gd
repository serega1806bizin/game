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

# --- GOOGLE FORM URL ---
const GOOGLE_URL := "https://docs.google.com/forms/d/e/1FAIpQLScwKh4w8TQ2gKNci0YvOZ8zg3G19t0jhadFmF6q-Mzz8zgVHg/viewform"


func _ready() -> void:
	# скрыть форму
	form_panel.visible = false
	contact_label.visible = false
	contact_field.visible = false

	# сигналы
	btn_abit.pressed.connect(_on_abit)
	btn_student.pressed.connect(_start_game)
	check_info.toggled.connect(_on_toggle_info)
	start_game_btn.pressed.connect(_on_submit)


# --- 1. Открыть форму ---
func _on_abit():
	start_panel.visible = false
	form_panel.visible = true


# --- 2. Чекбокс → показать контакт ---
func _on_toggle_info(checked: bool) -> void:
	contact_label.visible = checked
	contact_field.visible = checked


# --- ВСПОМОГАТЕЛЬНОЕ: кодируем параметры ---
func encode(s: String) -> String:
	return s.uri_encode()

func dict_to_query_string(d: Dictionary) -> String:
	var parts: Array[String] = []
	for key in d.keys():
		parts.append("%s=%s" % [ encode(str(key)), encode(str(d[key])) ])
	return "&".join(parts)


# --- 3. Отправка формы ---
func _on_submit():
	var wants_info: bool = check_info.button_pressed  # ✅ теперь всё ок

	var data := {
		"entry.1527170952": name_field.text.strip_edges(),
		"entry.542459924": school_field.text.strip_edges(),
		"entry.1136122744": spec_field.text.strip_edges(),
		"entry.1139989332": (contact_field.text.strip_edges() if wants_info else "--"),
		"entry.575420519": ("Так" if wants_info else "Ні")
	}

	var body := dict_to_query_string(data)

	var request := HTTPRequest.new()
	add_child(request)
	await request.ready

	var err = request.request(
		GOOGLE_URL,
		[],
		HTTPClient.METHOD_POST,
		body
	)

	if err != OK:
		print("❌ Ошибка HTTP:", err)
	else:
		print("✔ Данные отправлены!")

	_start_game()


# --- 4. Переход в игру ---
func _start_game():
	get_tree().change_scene_to_file("res://хол.tscn")
