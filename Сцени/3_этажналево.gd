extends Node2D

@onready var coin_label: Label = $"UI/HUD/CoinLabel"   # путь должен быть твой
												  # если не так — скажи, посмотрим точный

func _ready():
	update_coins() 
	# Автоматически подключаем ВСЕ монетки
	for c in get_tree().get_nodes_in_group("coins"):
		c.collected.connect(_on_coin_collected)
		
	for c in get_tree().get_nodes_in_group("coins"):
		if GameState.collected_coins.has(c.coin_id):
			c.queue_free()
			
func _on_coin_collected():
	GameState.coins += 1
	update_coins()

func update_coins():
	coin_label.text = str(GameState.coins)
