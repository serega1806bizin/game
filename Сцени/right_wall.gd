extends Area2D

@export var next_scene: String = "res://Сцени/хол.tscn"
@export var spawn_point_name: String = "SpawnFromRight"

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.name == "Player":
		GameState.spawn_point_name = spawn_point_name
		get_tree().change_scene_to_file(next_scene)
