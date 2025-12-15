extends Node2D

@onready var coin_label: Label = $"UI/HUD/CoinLabel"   # путь должен быть твой
												  # если не так — скажи, посмотрим точный

func _ready():
	update_coins() 

func update_coins():
	coin_label.text = str(GameState.coins)
