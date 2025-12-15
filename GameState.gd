extends Node

var spawn_point_name: String = ""
var coins = 0
var collected_coins = {}

func add_coin():
	coins += 1
	print("Coins:", coins)
