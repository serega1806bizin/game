extends Button

@export var current_panel_path: NodePath
@export var form_path: NodePath

var current_panel: Panel
var form: Panel

func _ready():
	if current_panel_path != NodePath():
		current_panel = get_node(current_panel_path)

	if form_path != NodePath():
		form = get_node(form_path)

	pressed.connect(_on_pressed)

func _on_pressed():
	if current_panel:
		current_panel.visible = false

	if form:
		form.visible = true
