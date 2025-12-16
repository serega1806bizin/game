extends Node

var is_mobile := false

func _ready():
	var name := OS.get_name()
	is_mobile = name == "Android" or name == "iOS"
