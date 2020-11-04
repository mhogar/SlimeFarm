extends CanvasLayer

signal simulation_start

onready var GUI := $GUI
onready var TilesXSelector := $GUI/VBoxContainer/VBoxContainer2/TilesXSelector
onready var TilesYSelector := $GUI/VBoxContainer/VBoxContainer2/TilesYSelector
onready var PopSizeSelector := $GUI/VBoxContainer/VBoxContainer2/PopSizeSelector
onready var NumFoodSelector := $GUI/VBoxContainer/VBoxContainer2/NumFoodSelector
onready var MutProbSelector := $GUI/VBoxContainer/VBoxContainer2/MutProbSelector


func hide():
	GUI.hide()

func get_num_tiles_x() -> int:
	return TilesXSelector.get_value()


func get_num_tiles_y() -> int:
	return TilesYSelector.get_value()


func get_population_size() -> int:
	return PopSizeSelector.get_value()


func get_num_food() -> int:
	return NumFoodSelector.get_value()
	
	
func get_mutation_probability() -> float:
	return MutProbSelector.get_value()


func _on_Button_pressed():
	emit_signal("simulation_start")
