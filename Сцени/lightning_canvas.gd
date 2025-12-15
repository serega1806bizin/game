extends ColorRect

var bolts = []
var flash = 0.0


func trigger_lightning(x = null):
	var start_x = x if x != null else size.x/2
	bolts.append({
		"points": _generate_bolt(start_x),
		"life": 0,
		"max": 18 + randi()%14
	})
	flash = 1.0
	queue_redraw()


func _generate_bolt(x):
	var pts = []
	var y := 0.0
	for i in range(20):
		var nx = x + randf_range(-25,25)
		var ny = y + randf_range(20,40)
		pts.append(Vector2(nx,ny))
		x = nx
		y = ny
	return pts


func _draw():
	if flash > 0:
		draw_rect(Rect2(Vector2.ZERO, size), Color(1,1,1,flash*0.3))

	for b in bolts:
		var t = 1.0 - float(b.life) / b.max
		var col = Color(0.8,0.9,1,t)
		draw_polyline(b.points, col, 2)

	# оновимо стан
	flash -= 0.05
	if flash < 0:
		flash = 0

	for b in bolts:
		b.life += 1

	bolts = bolts.filter(func(b): return b.life < b.max)

	if bolts.size() > 0 or flash > 0:
		queue_redraw()
