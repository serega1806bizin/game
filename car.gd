extends Area2D

@export var speed := 500.0
@export var texture_faces_right := true

@onready var sprite: Sprite2D = $Sprite2D

var dir: Vector2 = Vector2.RIGHT
signal hit_player

func set_car_texture(tex: Texture2D) -> void:
	sprite.texture = tex

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	$VisibleOnScreenNotifier2D.screen_exited.connect(queue_free)

func _physics_process(delta: float) -> void:
	position += dir * speed * delta

func set_direction(d: Vector2) -> void:
	dir = d.normalized()
	var moving_left := dir.x < 0.0
	sprite.flip_h = moving_left if texture_faces_right else (not moving_left)

func _on_body_entered(body: Node) -> void:
	if body is CharacterBody2D:
		hit_player.emit()
