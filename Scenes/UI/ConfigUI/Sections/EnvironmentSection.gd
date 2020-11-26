extends "res://Scenes/UI/ConfigUI/Sections/CollapsibleSection.gd"

onready var TilesXSelector := $Body/Selectors/TilesXSelector
onready var TilesYSelector := $Body/Selectors/TilesYSelector
onready var PopSizeSelector := $Body/Selectors/PopSizeSelector
onready var NumFoodSelector := $Body/Selectors/NumFoodSelector
onready var UpdateButton := $Body/UpdateButton


func load_from_config():
	TilesXSelector.set_value(Config.num_tiles_x)
	TilesYSelector.set_value(Config.num_tiles_y)
	PopSizeSelector.set_value(Config.population_size)
	NumFoodSelector.set_value(Config.num_food)


func disable_editing():
	.disable_editing()
	UpdateButton.disabled = true


func enable_editing():
	.enable_editing()
	UpdateButton.disabled = false


func _on_UpdateButton_pressed():
	Config.num_tiles_x = TilesXSelector.get_value()
	Config.num_tiles_y = TilesYSelector.get_value()
	Config.population_size = PopSizeSelector.get_value()
	Config.num_food = NumFoodSelector.get_value()
	
	get_tree().call_group("config", "environment_config_changed")
