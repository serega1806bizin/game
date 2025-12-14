extends Node2D

@export var car_scene: PackedScene
@export var car_textures: Array[Texture2D] = []

@export var min_delay := 5.0
@export var max_delay := 9.0
@export var min_speed := 380.0
@export var max_speed := 650.0

@onready var game_over = $"../UI/HUD/GameOverModal"
@onready var timer: Timer = $Timer
@onready var cars_parent: Node2D = $"../Cars"
@onready var markers: Node2D = $"../Markers"

@onready var spawn_left: Marker2D = markers.get_node("CarSpawnLeft")
@onready var spawn_right: Marker2D = markers.get_node("CarSpawnRight")

var lanes: Array[Marker2D] = []
var _tex_index := 0
var _game_over_shown := false

func _ready() -> void:
	randomize()

	lanes = [
		markers.get_node("Lane1"),
		markers.get_node("Lane2"),
		markers.get_node("Lane3"),
	]

	# Restart из модалки
	if game_over and game_over.has_signal("restart_requested"):
		game_over.restart_requested.connect(_restart_game)

	timer.timeout.connect(_on_timeout)
	_reset_timer()

func _reset_timer() -> void:
	timer.wait_time = randf_range(min_delay, max_delay)
	timer.start()

func _on_timeout() -> void:
	if _game_over_shown:
		return
	spawn_car()
	_reset_timer()

func spawn_car() -> void:
	if car_scene == null:
		push_warning("Назначь car_scene в инспекторе CarSpawner!")
		return

	var car = car_scene.instantiate()
	cars_parent.add_child(car)

	# Раз через раз меняем картинку
	if car_textures.size() > 0:
		var tex := car_textures[_tex_index % car_textures.size()]
		if tex != null:
			car.set_car_texture(tex)
		_tex_index += 1

	var lane: Marker2D = lanes[randi() % lanes.size()]
	var from_left := (randi() % 2) == 0

	# Скорость
	car.speed = randf_range(min_speed, max_speed)

	# Позиция + направление
	if from_left:
		car.global_position = Vector2(spawn_left.global_position.x, lane.global_position.y)
		car.set_direction(Vector2.RIGHT)
	else:
		car.global_position = Vector2(spawn_right.global_position.x, lane.global_position.y)
		car.set_direction(Vector2.LEFT)

	# Сбитие игрока
	car.hit_player.connect(_on_player_hit)

func _on_player_hit() -> void:
	if _game_over_shown:
		return

	_game_over_shown = true
	timer.stop()                 # чтобы новые машины не спавнились
	get_tree().paused = true     # пауза игры

	# показать модалку
	if game_over and game_over.has_method("show_game_over"):
		game_over.show_game_over("Гра закінчена.")
	else:
		# если вдруг модалка без метода — хотя бы перезапуск
		get_tree().paused = false
		get_tree().reload_current_scene()

func _restart_game() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
