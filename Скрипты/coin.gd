extends Area2D

signal collected
@export var coin_id: String = ""

func _ready():
	add_to_group("coins")  # ← добавляем монетку в группу
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	if body.name == "Player":
		GameState.collected_coins[coin_id] = true
		emit_signal("collected")
		queue_free()
