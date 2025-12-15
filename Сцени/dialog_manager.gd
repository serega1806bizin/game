extends Node

@onready var modal = $"../ModalDialog"
@onready var lightning = $"../LightningCanvas"


var lesson_done := false


func _ready():
	start_lesson()


func start_lesson():
	if lesson_done:
		exit_scene()
		return

	modal.show_modal(
		"Кабінет фізики. На столі — куля з блискавками.",
		[
			{"label":"Роздивитись ближче", "callback": func(): intro("normal")},
			{"label":"Сісти тихенько", "callback": func(): intro("silent")},
			{"label":"Відкласти урок", "callback": func(): exit_scene()}
		]
	)


func intro(mode):
	var t = "Ви нахиляєтесь ближче. Блискавки тягнуться до пальців." if mode == "normal" \
	else "Ви сідаєте тихенько, але блискавки все одно дивляться на вас."


	modal.show_modal(
		t + "\n\nПара починається. Викладач вмикає кулю — вона спалахує.",
		[
			{"label":"Чекаю, що він скаже", "callback": teacher_intro}
		]
	)


func teacher_intro():
	modal.show_modal(
		"Викладач:\n«Отже, плазмова куля. Можна торкнутись — не вдарить.»",
		[
			{"label":"Посміхнутись", "callback": func(): student_comment("normal")},
			{"label":"Пильно подивитись", "callback": func(): student_comment("observe")}
		]
	)


func student_comment(mode):
	var txt = "Одногрупник шепче:\n«Минулого року її включали — аж світло мигало.»" \
		if mode == "observe" \
		else "Одногрупник каже:\n«Минулого року її включали — аж мигало у всьому корпусі.»"

	modal.show_modal(
		txt,
		[
			{"label":"Посміхнутись", "callback": teacher_joke}
		]
	)



func teacher_joke():
	modal.show_modal(
		"Викладач усміхається:\n«Тоді хтось підключив чайник і зарядку одночасно.»",
		[
			{"label":"Сміятись", "callback": ask_touch},
			{"label":"Промовчати", "callback": ask_touch}
		]
	)


func ask_touch():
	modal.show_modal(
		"Викладач:\n«Ну що, хто хоче доторкнутись?»",
		[
			{"label":"Доторкнутись", "callback": touch},
			{"label":"Пожартувати", "callback": joke_path},
			{"label":"Серйозно спитати", "callback": serious},
			{"label":"Відмовитись", "callback": refuse}
		]
	)


func touch():
	lightning.trigger_lightning()
	modal.show_modal(
		"Ваш палець тягнеться до кулі. Блискавка легенько торкається шкіри.",
		[
			{"label":"О, прикольно!", "callback": teacher_beauty}
		]
	)


func teacher_beauty():
	modal.show_modal(
		"Викладач:\n«Бачите, наука — це красиво.»",
		[
			{"label":"Повернутись на місце", "callback": end_lesson}
		]
	)


func joke_path():
	modal.show_modal(
		"Ви кажете:\n«А якщо потримати довше, світло зникне?»",
		[
			{"label":"Чекати реакцію", "callback": teacher_jokes_back}
		]
	)


func teacher_jokes_back():
	modal.show_modal(
		"Викладач (жартома):\n«Якщо ввірю — то може.»",
		[
			{"label":"Торкнутись тепер", "callback": touch},
			{"label":"Повернутись", "callback": end_lesson}
		]
	)


func serious():
	modal.show_modal(
		"Ви питаєте:\n«Чому блискавка тягнеться до пальця?»",
		[
			{"label":"Слухати відповідь", "callback": teacher_physics}
		]
	)


func teacher_physics():
	modal.show_modal(
		"Викладач:\n«Бо ти створюєш точку більшого поля.»",
		[
			{"label":"А виглядає як фокус!", "callback": teacher_final}
		]
	)


func teacher_final():
	modal.show_modal(
		"Викладач:\n«Фізика — це чарівність пояснень.»",
		[
			{"label":"Повернутись", "callback": end_lesson}
		]
	)

func refuse1():
	lightning.trigger_lightning()
	end_lesson()

func refuse():
	modal.show_modal(
		"Ви кажете:\n«Та ні, я пас…»",
		[
			{
				"label": "Спостерігати, як пробує інший",
				"callback": refuse1
			}
		]
	)


func end_lesson():
	modal.show_modal(
		"Експеримент пройшов успішно.",
		[
			{"label":"Вийти", "callback": exit_scene}
		]
	)


func exit_scene():
	lesson_done = true
	get_tree().change_scene_to_file("res://Сцени/2этажналево.tscn")
