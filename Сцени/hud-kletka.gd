extends Control

@onready var dialog = $DialogModal
@onready var choose_modal = $ChooseModal

@onready var btn_eat = $"ChooseModal/Panel/Eat"
@onready var btn_talk = $"ChooseModal/Panel/Talk"
@onready var btn_rest = $"ChooseModal/Panel/Chill"

# Аватарки
@onready var ava_eva = $"../../Actors/Eva"
@onready var ava_lera = $"../../Actors/Lera"
@onready var ava_sergiy = $"../../Actors/Serhii"

var stage = 0

func _ready():
	btn_eat.pressed.connect(_on_eat)
	btn_talk.pressed.connect(_on_talk)
	btn_rest.pressed.connect(_on_rest)
	dialog.choice_selected.connect(_on_dialog_choice)


# ─────────────────────────────────────────────
#  СТАРТ ДІАЛОГУ
# ─────────────────────────────────────────────
func _on_talk():
	choose_modal.visible = false
	stage = 1

	dialog.open_dialog(
		ava_sergiy.texture,
		"Сергій: «О, привіт! Ти ж з першого курсу, да?»",
		[
			"Просто на перерві забіг, тут тихіше трохи.",
			"А ви з якої групи?"
		]
	)


# ─────────────────────────────────────────────
#  ГОЛОВНИЙ РОУТЕР ДІАЛОГІВ
# ─────────────────────────────────────────────
func _on_dialog_choice(id: int):
	match stage:
		0: 
			_exit_dialog()
			return
		1: _branch_intro(id)

		# Quiet route
		2: _quiet_1()
		3: _quiet_2()
		4: _quiet_3()
		5: _quiet_4()
		6: _quiet_final()

		# Group route
		20: _group_1()
		21: _group_2()
		22: _group_3()
		23: _group_4()
		24: _group_5()
		25: _group_6()

		99: _exit_dialog()


# ─────────────────────────────────────────────
#  РОЗГАЛУЖЕННЯ ПЕРШИХ ВИБОРІВ
# ─────────────────────────────────────────────
func _branch_intro(id: int):
	if id == 1:
		stage = 2
		dialog.open_dialog(
			ava_eva.texture,
			"Єва:\n«Ну да, у коридорі зараз такий шум, ніби безкоштовну каву роздають.»",
			["Далі"]
		)
	else:
		stage = 20
		dialog.open_dialog(
			ava_eva.texture,
			"Єва:\n«Ми з ПЗ-222 і ПЗ-221.»",
			["У нас зараз “вікно”, от і зависли тут"]
		)


# ─────────────────────────────────────────────
#  QUIET — ПОВНИЙ ЛАНЦЮГ ДІАЛОГУ
# ─────────────────────────────────────────────
func _quiet_1():
	stage = 3
	dialog.open_dialog(
		ava_lera.texture,
		"Лера:\n«Та тут завжди спокійно. Ми тут сидимо майже кожну перерву.»",
		["Та норм місце, атмосферне"]
	)

func _quiet_2():
	stage = 4
	dialog.open_dialog(
		ava_sergiy.texture,
		"Хлопець:\n«Ага, головне, що батарея тепла.»",
		["І вайфай ловить"]
	)

func _quiet_3():
	stage = 5
	dialog.open_dialog(
		ava_eva.texture,
		"Єва:\n«І ніхто не жене.»",
		["Ну от, ідеальна точка виживання"]
	)

func _quiet_4():
	stage = 6
	dialog.open_dialog(
		ava_lera.texture,
		"Лера:\n«Ну добре, буду я йти, бо скоро наступна пара.»",
		["Вийти"]
	)

func _quiet_final():
	stage = 99
	dialog.open_dialog(
		ava_lera.texture,
		"Лера:\n«Бувай!»",
		["Закрити"]
	)


# ─────────────────────────────────────────────
#  GROUP — ПОВНИЙ ЛАНЦЮГ ДІАЛОГУ
# ─────────────────────────────────────────────
func _group_1():
	stage = 21
	dialog.open_dialog(
		ava_sergiy.texture,
		"Сергій: \n«О ну класно вам, просто в нас кожна пара в різній аудиторії, то я вже заблукав трохи.»",
		["Далі"]
	)

func _group_2():
	stage = 22
	dialog.open_dialog(
		ava_lera.texture,
		"Лера:\n«А, знайомо. Ми теж так блудимо кожного дня — шукаєш, де перша, потім де друга, потім вже забив і йдеш на запах крейди.»",
		["Найгірше — коли дві різні пари підряд в різних корпусах."]
	)

func _group_3():
	stage = 23
	dialog.open_dialog(
		ava_eva.texture,
		"Єва:\n«Або коли ти вже сидиш, а виявляється, що це не твоя група.»",
		["Було..."]
	)

func _group_4():
	stage = 24
	dialog.open_dialog(
		ava_sergiy.texture,
		"Сергій: \n«Було. Сидів до середини пари, поки не зрозумів, що викладач до мене не звертається, бо я тут зайвий.»",
		["Класика технікуму"]
	)

func _group_5():
	stage = 25
	dialog.open_dialog(
		ava_eva.texture,
		"Єва:\n«Якщо не заблукав — день прожитий дарма.»",
		["Ну добре, буду я йти"]
	)

func _group_6():
	stage = 99
	dialog.open_dialog(
		ava_sergiy.texture,
		"Сергій: \n«Бувай!»",
		["Закрити"]
	)


# ─────────────────────────────────────────────
#  ВИХІД З ДІАЛОГУ
# ─────────────────────────────────────────────
func _exit_dialog():
	choose_modal.visible = true
	btn_talk.visible = false


# ─────────────────────────────────────────────
#  ОКРЕМІ ДІЇ
# ─────────────────────────────────────────────
func _on_eat():
	choose_modal.visible = false
	dialog.open_dialog(
		ava_sergiy.texture,
		"Ти спокійно сів їсти свій бутерброд.",
		["Добре"]
	)
	stage = 0  # щоб повернути кнопки


func _on_rest():
	choose_modal.visible = false
	dialog.open_dialog(
		ava_eva.texture,
		"Ти трохи видихнув і розслабився.",
		["Добре"]
	)
	stage = 0
