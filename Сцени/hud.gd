extends Control

# Узлы диалоговой модалки
@onready var dialog = $DialogModal

# Кнопки выбора действия
@onready var btn_eat: Button  = $"ChooseModal/Panel/Eat"
@onready var btn_talk: Button = $"ChooseModal/Panel/Talk"
@onready var btn_rest: Button = $"ChooseModal/Panel/Chill"


# Аватарки
@onready var ava_eva: Sprite2D = $"../../Actors/Eva"
@onready var ava_lera: Sprite2D = $"../../Actors/Lera"
@onready var ava_sergiy: Sprite2D = $"../../Actors/Serhii"

var stage = 0

func _ready():
	btn_eat.pressed.connect(_on_eat)
	btn_talk.pressed.connect(_on_talk)
	btn_rest.pressed.connect(_on_rest)

	dialog.choice_selected.connect(_on_dialog_choice)


# ─────────────────────────────────────────────
#  ВЫБОР "ПОГОВОРИТЬ" — запускаем диалог
# ─────────────────────────────────────────────
func _on_talk():
	stage = 1

	dialog.open_dialog(
		ava_sergiy.texture,
		"Хлопець:\n«О, привіт! Ти ж з першого курсу, да?»",
		[
			"Просто на перерві забіг, тут тихіше трохи.",
			"А ви з якої групи?"
		]
	)


# ─────────────────────────────────────────────
#  ВЫБОРЫ В ДИАЛОГЕ
# ─────────────────────────────────────────────
func _on_dialog_choice(id: int):
	match stage:
		1: _branch_intro(id)
		2: _branch_quiet(id)
		3: _branch_group(id)
		10: _exit_dialog()


# ─────────────────────────────────────────────
#  ПЕРВЫЙ ВИБІР
# ─────────────────────────────────────────────
func _branch_intro(id: int):
	match id:
		1:
			stage = 2
			dialog.open_dialog(
				ava_lera.texture,
				"Дівчина 1:\n«Ну да, у коридорі шум…»",
				["Далі"]
			)
		2:
			stage = 3
			dialog.open_dialog(
				ava_eva.texture,
				"Дівчина 1:\n«Ми з ПЗ-222…»",
				["Далі"]
			)


# ─────────────────────────────────────────────
#  Ветвь ТИХО
# ─────────────────────────────────────────────
func _branch_quiet(id: int):
	stage = 10
	dialog.open_dialog(
		ava_sergiy.texture,
		"Дівчина 2:\n«Тут завжди спокійно.»",
		["Вийти"]
	)


# ─────────────────────────────────────────────
#  Ветвь ГРУПА
# ─────────────────────────────────────────────
func _branch_group(id: int):
	stage = 10
	dialog.open_dialog(
		ava_eva.texture,
		"Хлопець:\n«О, знайомо…»",
		["Вийти"]
	)


# ─────────────────────────────────────────────
#  ВЫХОД ИЗ ДИАЛОГА
# ─────────────────────────────────────────────
func _exit_dialog():
	# Нічого не робимо, просто закривається
	pass


# ─────────────────────────────────────────────
#  ДРУГІ КНОПКИ МОДАЛКИ
# ─────────────────────────────────────────────
func _on_eat():
	print("игрок покушал")

func _on_rest():
	print("игрок отдыхает")
