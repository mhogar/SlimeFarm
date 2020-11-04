extends HBoxContainer

onready var Label := $Label
onready var Slider := $HSlider
onready var SpinBox := $SpinBox

export(String, MULTILINE) var label : String
export(String, MULTILINE) var hint : String

export var min_value : float
export var max_value : float
export var default_value : float
export var step : float


func _ready():
	hint_tooltip = hint
	
	Label.text = label
	
	SpinBox.min_value = min_value
	SpinBox.max_value = max_value
	SpinBox.step = step
	
	Slider.min_value = min_value
	Slider.max_value = max_value
	Slider.step = step
	
	SpinBox.value = default_value
	Slider.value = default_value


func get_value() -> float:
	return SpinBox.value


func _on_HSlider_value_changed(value):
	SpinBox.value = value


func _on_SpinBox_value_changed(value):
	Slider.value = value
