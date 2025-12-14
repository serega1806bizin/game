extends Control

signal restart_requested

@onready var text_label: Label = $Text
@onready var text_label2: Label = $Text2
@onready var text_label3: Label = $Text3
@onready var restart_btn: Button = $RestartBtn

func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS  # важно! чтобы кнопка работала на паузе
	restart_btn.pressed.connect(func():
		restart_requested.emit()
	)

func show_game_over(msg: String) -> void:
	text_label.text = msg
	visible = true
	
func show_game_over_1(msg: String) -> void:
	text_label.text = msg
	text_label2.text = "Ви затрималися в магазині та запізнилися"
	text_label3.visible = false		
	visible = true
