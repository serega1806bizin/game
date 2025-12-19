extends Control

func _ready() -> void:
	# Android/iOS — показываем
	# Web — показываем только если устройство реально тачевое
	var is_mobile := OS.get_name() in ["Android", "iOS"]
	var is_touch_web := OS.get_name() == "Web" and DisplayServer.is_touchscreen_available()

	visible = is_mobile or is_touch_web
