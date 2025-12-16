extends Node

var spawn_point_name: String = ""
var coins: int = 0
var collected_coins = {}

var math_done: bool = false
var physics_done: bool = false
var informatics_done: bool = false


func add_coin():
	coins += 1
	print("Coins:", coins)


func all_lessons_done() -> bool:
	return (math_done and physics_done and informatics_done)

var final_panel_scene := preload("res://Сцени/final_panel.tscn")


func show_final_panel():
	var p = final_panel_scene.instantiate()
	get_tree().root.add_child(p)
	p.show_panel()
	return p
