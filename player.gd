extends CharacterBody2D

@export var speed := 220.0
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var joystick_dir := Vector2.ZERO

var move_dir := Vector2.ZERO
@onready var joystick := $"../UI/HUD/VirtualJoystick"

func _process(delta):
	if Device.is_mobile:
		_move_mobile()
	else:
		_move_pc()

	move_and_slide()
func _move_mobile():
	move_dir = joystick.get_direction() # Вернет Vector2
	velocity = move_dir * 120  # скорость
func _move_pc():
	var input = Vector2.ZERO
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	velocity = input.normalized() * 120
	

func _ready() -> void:
	if GameState.spawn_point_name != "":
		var marker := get_parent().get_node_or_null(GameState.spawn_point_name)
		if marker:
			global_position = marker.global_position
		GameState.spawn_point_name = ""

func set_joystick_dir(d: Vector2) -> void:
	joystick_dir = d

func _physics_process(delta: float) -> void:
	var kb := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var dir := kb + joystick_dir
	if dir.length() > 1.0:
		dir = dir.normalized()

	velocity = dir * speed
	move_and_slide()

	_update_animation(dir)

func _update_animation(dir: Vector2) -> void:
	if dir == Vector2.ZERO:
		if anim.animation != "idle":
			anim.animation = "idle"
		anim.play()
		return

	# направление
	if abs(dir.x) > 0.1:
		anim.flip_h = dir.x < 0

	if anim.animation != "walk":
		anim.animation = "walk"
	anim.play()
