extends Node

@onready var modal = $"../ModalDialog"

var is_lesson_done := false

# -----------------------------------------
#      ЗАДАЧИ
# -----------------------------------------
var code_tasks = [
	{
		"id":"hello-world",
		"title":"Задача 1: перший Hello, world!",
		"description":"Напиши команду JavaScript, яка виведе:\nHello, world!",
		"answers":[
			"console.log('Hello, world!');",
			"console.log(\"Hello, world!\");",
			"console.log('Hello, world!')",
			"console.log(\"Hello, world!\")"
		]
	},
	{
		"id":"hello-tech",
		"title":"Задача 2: привітати технар",
		"description":"Напиши команду, яка виведе:\nHello, технар!",
		"answers":[
			"console.log('Hello, технар!');",
			"console.log(\"Hello, технар!\");",
			"console.log('Hello, технар!')",
			"console.log(\"Hello, технар!\")"
		]
	},
	{
		"id":"sum-console",
		"title":"Задача 3: трошки математики",
		"description":"Напиши команду, яка виведе результат 2 + 3.",
		"answers":[
			"console.log(2 + 3);",
			"console.log(2+3);",
			"console.log(2 + 3)",
			"console.log(2+3)"
		]
	}
]

var current_task := 0


func _ready():
	# Если урок уже завершён — сразу выходим (без зависаний)
	if GameState.informatics_done:
		await exit_scene_async()
		return

	start_lesson()


# ============================================================
#                      СТАРТ УРОКА
# ============================================================

func start_lesson():
	if is_lesson_done:
		await exit_scene_async()
		return

	current_task = 0

	modal.show_modal(
		"Кабінет інформатики.\nМонітори ввімкнені.\nНа дошці написано:\nconsole.log(\"Hello, world!\")",
		[
			{"label":"Сісти за комп'ютер", "callback": sit_down}
		]
	)


func sit_down():
	modal.show_modal(
		"Ти сідаєш за комп. Викладач вмикає проектор.",
		[
			{"label":"Чекати, що він скаже", "callback": teacher_intro}
		]
	)


func teacher_intro():
	modal.show_modal(
		"Викладач:\n«Сьогодні практичне. Кожен напише першу програму!»",
		[
			{"label":"Я готовий", "callback": start_code_practice}
		]
	)


# ============================================================
#                     ЗАДАЧИ
# ============================================================

func start_code_practice():
	current_task = 0
	show_task()


func show_task():
	var t = code_tasks[current_task]

	var msg = "%s\n\n%s\n\nВведи команду:" % [
		t["title"],
		t["description"]
	]

	modal.show_modal(
		msg,
		[
			{"label":"Виконати", "callback": check_answer}
		],
		true  # есть input
	)


func check_answer(value: String):
	value = value.strip_edges()

	# Секретка =)
	if value == "228" or value == "console.log(228)":
		return secret_meme()

	# Пусто
	if value == "":
		return modal.show_modal(
			"Консоль мовчить. Команда порожня.",
			[
				{"label":"Спробувати ще раз", "callback": show_task}
			],
			true
		)

	var t = code_tasks[current_task]

	if _is_correct(value, t["answers"]):
		return task_correct()

	task_wrong()


func _normalize(s):
	return s.strip_edges().replace("  ", " ")


func _is_correct(code, arr):
	var user = _normalize(code)
	for a in arr:
		if _normalize(a) == user:
			return true
	return false


# ============================================================
#                     РЕАКЦИИ
# ============================================================

func task_correct1():
	current_task += 1
	show_or_end()


func task_correct():
	modal.show_modal(
		"ENTER… Вивід правильний.\nВикладач: «Добре!»",
		[
			{"label":"Далі", "callback": func(): task_correct1()}
		]
	)


func task_wrong1():
	current_task += 1
	show_or_end()


func task_wrong():
	modal.show_modal(
		"Помилка або пустий результат.\nВикладач: «Подивись на лапки та дужки!»",
		[
			{"label":"Спробувати знову", "callback": show_task},
			{"label":"Наступна задача", "callback": func(): task_wrong1()}
		]
	)


func secret_meme():
	modal.show_modal(
		"Викладач:\n«Любитель мемів? Ха-ха!»",
		[
			{"label":"Повернутись до задачі", "callback": show_task}
		]
	)


func show_or_end():
	if current_task < code_tasks.size():
		modal.show_modal(
			"Хочеш ще одну задачу?",
			[
				{"label":"Так", "callback": show_task},
				{"label":"Ні", "callback": end_lesson}
			]
		)
	else:
		no_more_tasks()


func no_more_tasks():
	modal.show_modal(
		"Викладач:\n«Базові команди є. Молодець!»",
		[
			{"label":"Дайте складніше", "callback": ultra_task_intro},
			{"label":"Досить на сьогодні", "callback": end_lesson}
		]
	)


func ultra_task_intro():
	modal.show_modal(
		"Викладач:\n«Добре. Тримай задачу для майбутнього.»",
		[
			{"label":"Слухаю", "callback": ultra_task_info}
		]
	)


func ultra_task_info():
	modal.show_modal(
		"Написати програму, що запитує імʼя, вітає, повторює до порожнього рядка.",
		[
			{"label":"Піти з ідеєю", "callback": end_lesson}
		]
	)


# ============================================================
#                     КОНЕЦ УРОКА
# ============================================================

func end_lesson():
	modal.show_modal(
		"Пара закінчується…",
		[
			{"label":"Вийти з кабінету", "callback": exit_scene_async}
		]
	)

@onready var panel = $"../Panel"

func exit_scene_async():
	if is_lesson_done:
		return

	is_lesson_done = true
	GameState.informatics_done = true

	# Конфетти если ВСЕ пары пройдены
	if GameState.all_lessons_done():
		await get_tree().create_timer(1.0).timeout
		panel.visible = true
		return

	get_tree().change_scene_to_file("res://Сцени/3этажналево.tscn")
