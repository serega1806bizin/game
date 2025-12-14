extends Control

@onready var shop_area: Area2D = $"../../Interactables/Shop"
@onready var shop_modal: Control = $ShopModal
@onready var game_over: Control = $GameOverModal

@onready var npc: Area2D = $"../../Interactables/NPC_Girl"
@onready var dialog: Control = $DialogModal

func _ready() -> void:
	shop_area.shop_pressed.connect(_on_shop_pressed)

	shop_modal.yes_pressed.connect(_on_shop_yes)
	shop_modal.no_pressed.connect(_on_shop_no)
	npc.npc_pressed.connect(_on_npc_pressed)
	dialog.finished.connect(_on_dialog_finished)

func _on_shop_pressed() -> void:
	shop_modal.open()
func _on_npc_pressed() -> void:
	# ставим паузу
	get_tree().paused = true

	# реплики (любые, я придумал короткий диалог с вариантом ответа в следующем шаге)
	var lines: Array[String] = [
		"— Привіт! Ти теж на пари йдеш?",
		"— Так... але щось сьогодні лінь.",
		"— Якщо підеш зараз — ще встигнеш. Не зависай тут 🙂"
	]
	dialog.open_dialog("Оля", lines)


func _on_dialog_finished() -> void:
	# пометили, что уже показывали
	if npc.has_method("mark_shown"):
		npc.mark_shown()

	# снимаем паузу
	get_tree().paused = false
func _on_shop_no() -> void:
	shop_modal.close()

func _on_shop_yes() -> void:
	shop_modal.close()
	get_tree().paused = true
	game_over.show_game_over_1("Ви програли.")
