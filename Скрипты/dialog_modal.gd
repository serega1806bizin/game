extends Panel

signal finished

@onready var name_label: Label = $Name
@onready var text_label: Label = $Text
@onready var next_btn: Button = $NextBtn

var lines: Array[String] = []
var idx := 0
var active := false

# ТОЛЬКО эту реплику показываем в кнопке (и НЕ выводим в Text)
const PLAYER_REPLY_IN_BUTTON := "— Так... але щось сьогодні лінь."

func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	next_btn.pressed.connect(_on_next_pressed)

func open_dialog(npc_name: String, dialog_lines: Array[String]) -> void:
	if active:
		return

	name_label.text = npc_name
	lines = dialog_lines
	idx = 0
	active = true
	visible = true
	_update_ui()

func _update_ui() -> void:
	if idx < 0 or idx >= lines.size():
		text_label.text = ""
		next_btn.text = "Закрити"
		return

	# Текущая реплика в тексте (кроме той, что должна быть только в кнопке)
	if lines[idx] == PLAYER_REPLY_IN_BUTTON:
		# вообще не показываем её в тексте
		text_label.text = ""
	else:
		text_label.text = lines[idx]

	# --- Логика кнопки ---
	# Если следующая реплика — наша "особая", то покажем ЕЁ в кнопке
	if idx + 1 < lines.size() and lines[idx + 1] == PLAYER_REPLY_IN_BUTTON:
		next_btn.text = PLAYER_REPLY_IN_BUTTON
	elif idx + 1 < lines.size():
		next_btn.text = "Далі"
	else:
		next_btn.text = "Закрити"

func _on_next_pressed() -> void:
	if not active:
		return

	# Если сейчас на кнопке была "особая" реплика — пропускаем её в тексте
	# и перескакиваем сразу на следующую (NPC продолжение)
	if idx + 1 < lines.size() and lines[idx + 1] == PLAYER_REPLY_IN_BUTTON:
		# пропускаем строку PLAYER_REPLY_IN_BUTTON (idx+1)
		idx += 2
	else:
		idx += 1

	if idx < lines.size():
		_update_ui()
	else:
		close_dialog()
		finished.emit()

func close_dialog() -> void:
	visible = false
	active = false
