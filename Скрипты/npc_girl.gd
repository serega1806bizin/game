extends Area2D

signal npc_pressed

@export var one_time_only := true
var was_shown := false
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	input_pickable = true  # важно для клика по Area2D
	anim.play("default")

func _input_event(viewport, event, shape_idx) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if one_time_only and was_shown:
			return
		npc_pressed.emit()

func mark_shown() -> void:
	was_shown = true
