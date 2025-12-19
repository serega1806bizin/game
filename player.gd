extends CharacterBody2D

@export var speed := 220.0
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	if GameState.spawn_point_name != "":
		var marker := get_parent().get_node_or_null(GameState.spawn_point_name)
		if marker:
			global_position = marker.global_position
		GameState.spawn_point_name = ""

func _physics_process(delta: float) -> void:
	# одно управление для всего:
	# ПК: стрелки/WASD (если назначишь в InputMap)
	# мобилка: TouchScreenButton "жмёт" эти же действия
	var dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")

	velocity = dir * speed
	move_and_slide()

	_update_animation(dir)

func _update_animation(dir: Vector2) -> void:
	if dir == Vector2.ZERO:
		if anim.animation != "idle":
			anim.animation = "idle"
		anim.play()
		return

	if abs(dir.x) > 0.1:
		anim.flip_h = dir.x < 0

	if anim.animation != "walk":
		anim.animation = "walk"
	anim.play()
