extends Control

onready var CollapseButton := $HBoxContainer/CollapseButton
onready var Body := $Body
onready var Selectors := $Body/Selectors


func _ready():
	collapse()


func collapse():
	CollapseButton.text = ">"
	Body.hide()


func expand():
	CollapseButton.text = "V"
	Body.show()


func load_from_config():
	for selector in Selectors.get_children():
		if selector.has_method("load_from_config"):
			selector.load_from_config()


func enable_editing():
	for selector in Selectors.get_children():
		if selector.has_method("enable_editing"):
			selector.enable_editing()


func disable_editing():
	for selector in Selectors.get_children():
		if selector.has_method("disable_editing"):
			selector.disable_editing()


func _on_CollapseButton_toggled(button_pressed):
	if button_pressed:
		expand()
	else:
		collapse()
