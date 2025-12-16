extends Control

@onready var dialog = $DialogModal
@onready var input_modal = $InputAnswerModal

var stage := 0
var currentIndex := 0
var superTaskDone := false
var isLessonDone := false

var mathTasks = [
	{ "q": "3 * 4 + 6 / 2 = ?", "a": "15" },
	{ "q": "Половина від третини числа 30 — це?", "a": "5" },
	{ "q": "Було 10 яблук. 3 з’їв, 2 подарував. Скільки залишилось?", "a": "5" },
	{ "q": "5 + 5 * 0 + 5 = ?", "a": "10" }
]

var hardTask = { "q": "(12 + 6) / 3 * 4 - 7 = ?", "a": "13" }


# ============================================================
#                      READY
# ============================================================

func _ready():
	# Заборона заходити двічі
	if GameState.math_done:
		await exit_scene_async()
		return

	startLesson()



# ============================================================
#                      СТАРТ УРОКУ
# ============================================================

func startLesson():
	if isLessonDone:
		return

	stage = 1
	dialog.open_dialog(
		"Викладач дивиться поверх окулярів. Привітатись?",
		[
			"Кивнути мовчки",
			"Привітатись",
			"Зробити вигляд, що не бачу"
		]
	)

	# Без дублювання connect
	if dialog.choice_selected.is_connected(_router):
		dialog.choice_selected.disconnect(_router)

	dialog.choice_selected.connect(_router)



# ============================================================
#                       РОУТЕР
# ============================================================

func _router(id):
	match stage:
		1: _intro(id)
		2: _greeting_type(id)
		3: _begin_lesson(id)

		4: _pretend_sick(id)
		5: _fake_fail(id)
		6: _teacher_angry_joke(id)
		7: _refuse_board(id)
		8: _angry_silent(id)

		100: pass
		110: _after_task_choice(id)
		120: _final_choice(id)



# ============================================================
#                       ПРИВІТАННЯ
# ============================================================

func _intro(id):
	if id == 3:
		dialog.open_dialog("Викладач прищурився. «Так… цікаво.»", ["Усміхнутись"])
		stage = 3
		return

	if id == 1:
		_begin_lesson_type("silent")
	elif id == 2:
		stage = 2
		dialog.open_dialog(
			"Як саме привітатись?",
			[
				"Добрий день!",
				"Ви сьогодні дуже гарно виглядаєте!",
				"Слава праці!"
			]
		)



func _greeting_type(id):
	match id:
		1: _begin_lesson_type("normal")
		2: _begin_lesson_type("flirt")
		3: _begin_lesson_type("weird")



# ============================================================
#        РЕАКЦІЯ ТА ПЕРЕХІД ДО ДОШКИ
# ============================================================

func _begin_lesson_type(t):
	var reaction := ""

	match t:
		"silent": reaction = "«Ну хоч так…»"
		"normal": reaction = "«Приємно чути.»"
		"flirt": reaction = "«Тримай себе в руках.»"
		"weird": reaction = "«Ем… добре.»"

	dialog.open_dialog(
		reaction + "\n\nТебе викликають до дошки. Що робити?",
		[
			"Іти",
			"Відмовитись",
			"Притворитися, що погано",
			"Мовчати"
		]
	)

	stage = 3



func _begin_lesson(id):
	match id:
		1: _start_tasks()

		2:
			stage = 7
			dialog.open_dialog("«Мінус 2 бали.»", ["Сісти"])

		3:
			stage = 4
			dialog.open_dialog("«Погано вам? Справді?»", ["Так…", "Та це жарт"])

		4:
			stage = 8
			dialog.open_dialog("«Мовчите? Це погано.»", ["Сісти"])



# ============================================================
#        ГІЛКИ ПЕРЕД ЗАДАЧАМИ
# ============================================================

func _pretend_sick(id):
	if id == 1:
		stage = 5
		dialog.open_dialog("«Сідай. Балів не буде.»", ["Сісти"])
	else:
		stage = 6
		dialog.open_dialog("«О, тепер точно до дошки!»", ["Добре"])



func _fake_fail(id):
	end_lesson()



func _teacher_angry_joke(id):
	_start_tasks()



func _refuse_board(id):
	end_lesson()



func _angry_silent(id):
	end_lesson()



# ============================================================
#                    СТАРТ ЗАДАЧ
# ============================================================

func _start_tasks():
	currentIndex = 0
	_show_next_task()



func _show_next_task():
	if currentIndex >= mathTasks.size():
		_no_more_tasks()
		return

	var task = mathTasks[currentIndex]
	stage = 100

	input_modal.open_task("Завдання %d:\n%s" % [currentIndex + 1, task["q"]])

	if input_modal.answer_submitted.is_connected(_check_task_answer):
		input_modal.answer_submitted.disconnect(_check_task_answer)

	input_modal.answer_submitted.connect(_check_task_answer)



func _check_task_answer(v):
	input_modal.answer_submitted.disconnect(_check_task_answer)

	if v == "228":
		_secret_meme()
		return

	var task = mathTasks[currentIndex]

	if v == task["a"]:
		_correct_task()
	else:
		_wrong_task()



func _correct_task():
	dialog.open_dialog("«Правильно! Молодець.»", ["Далі"])
	stage = 110



func _wrong_task():
	dialog.open_dialog("«Неправильно, але нічого.»", ["Спробувати іншу"])
	stage = 110



func _secret_meme():
	dialog.open_dialog("«228? Ха-ха… ну хитрий ти.» +1 бал", ["Далі"])
	stage = 110



func _after_task_choice(id):
	currentIndex += 1
	_show_or_finish()



func _show_or_finish():
	if currentIndex < mathTasks.size():
		stage = 110
		dialog.open_dialog(
			"Хочеш ще одну задачу?",
			[
				"Так, давайте ще!",
				"Ні, вистачить"
			]
		)
	else:
		_no_more_tasks()



# ============================================================
#                ФІНАЛ ЗАДАЧ
# ============================================================

func _no_more_tasks():
	stage = 120
	dialog.open_dialog(
		"«Ви сьогодні молодець, але задачі вже вичерпані.»",
		[
			"А можна складнішу?",
			"Добре, дякую"
		]
	)



func _final_choice(id):
	if id == 1:
		_show_hard_task()
	else:
		end_lesson()



# ============================================================
#              СУПЕРСКЛАДНА ЗАДАЧА
# ============================================================

func _show_hard_task():
	if superTaskDone:
		dialog.open_dialog("«Супер задача вже була. Більше немає.»", ["Окей"])
		end_lesson()
		return

	stage = 200
	input_modal.open_task("Супер задача:\n" + hardTask["q"])

	if input_modal.answer_submitted.is_connected(_check_hard):
		input_modal.answer_submitted.disconnect(_check_hard)

	input_modal.answer_submitted.connect(_check_hard)



func _check_hard(v):
	input_modal.answer_submitted.disconnect(_check_hard)
	superTaskDone = true

	if v == hardTask["a"]:
		dialog.open_dialog("«Вау… я вражений. +10 балів.»", ["Дякую!"])
	else:
		dialog.open_dialog("«Це дуже складно, не переймайтесь.»", ["Окей"])

	stage = 120



# ============================================================
#                   КІНЕЦЬ УРОКУ
# ============================================================

func end_lesson():
	dialog.open_dialog("Пара закінчилась.", ["Вийти"])
	stage = 999

	if dialog.choice_selected.is_connected(exit_scene):
		dialog.choice_selected.disconnect(exit_scene)

	dialog.choice_selected.connect(exit_scene)



# ============================================================
#                   ВИХІД З КАБІНЕТУ
# ============================================================

func exit_scene(id = 0):
	await exit_scene_async()

@onready var panel = $"../Panel"
# --- корутина ---
func exit_scene_async():
	isLessonDone = true
	GameState.math_done = true

	# Запускаємо конфетті, якщо всі пари пройдені
	if GameState.all_lessons_done():
		await get_tree().create_timer(1.0).timeout
		panel.visible = true
		return

	get_tree().change_scene_to_file("res://Сцени/1этажналево.tscn")
