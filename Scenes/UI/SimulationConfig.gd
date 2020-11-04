extends CanvasLayer

signal simulation_start
signal simulation_end

onready var GUI := $GUI
onready var Button := $GUI/VBoxContainer/Button

onready var SelectorContainer := $GUI/VBoxContainer/SelectorContainer
onready var TilesXSelector := $GUI/VBoxContainer/SelectorContainer/TilesXSelector
onready var TilesYSelector := $GUI/VBoxContainer/SelectorContainer/TilesYSelector
onready var PopSizeSelector := $GUI/VBoxContainer/SelectorContainer/PopSizeSelector
onready var NumFoodSelector := $GUI/VBoxContainer/SelectorContainer/NumFoodSelector
onready var MutProbSelector := $GUI/VBoxContainer/SelectorContainer/MutProbSelector
	

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


func hide():
	GUI.hide()
	
	
func show():
	GUI.show()


func disable_editing():
	for selector in SelectorContainer.get_children():
		selector.disable_editing()
	
	
func enable_editing():
	for selector in SelectorContainer.get_children():
		selector.enable_editing()


func start_simulation():
	Button.text = "End Simulation"
	disable_editing()
	emit_signal("simulation_start")


func end_simulation():
	Button.text = "Start Simulation"
	enable_editing()
	emit_signal("simulation_end")


func _on_Button_toggled(button_pressed):
	if button_pressed:
		start_simulation()
	else:
		end_simulation()
