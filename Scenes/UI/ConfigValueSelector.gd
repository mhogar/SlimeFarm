extends HBoxContainer

signal value_changed

onready var Label := $Label
onready var Slider := $HSlider
onready var SpinBox := $SpinBox
onready var HelpDialog := $HelpDialog

export(String, MULTILINE) var label : String
export(String, MULTILINE) var hint : String

export var min_value : float
export var max_value : float
export var step : float

var loaded := false


func _ready():
	HelpDialog.window_title = label
	HelpDialog.dialog_text = hint
	
	Label.text = label
	
	SpinBox.min_value = min_value
	SpinBox.max_value = max_value
	SpinBox.step = step
	
	Slider.min_value = min_value
	Slider.max_value = max_value
	Slider.step = step


func get_value() -> float:
	return SpinBox.value


func set_value(value : float):
	SpinBox.value = value
	Slider.value = value


func disable_editing():
	Slider.editable = false
	SpinBox.editable = false
	
	
func enable_editing():
	Slider.editable = true
	SpinBox.editable = true
	

# config group
func config_loaded():
	loaded = true


func _on_HSlider_value_changed(value):
	SpinBox.value = value
	if loaded:
		emit_signal("value_changed", value)


func _on_SpinBox_value_changed(value):
	Slider.value = value
	if loaded:
		emit_signal("value_changed", value)


func _on_HelpButton_pressed():
	HelpDialog.popup_centered(Config.DIALOG_POPUP_SIZE_S)
