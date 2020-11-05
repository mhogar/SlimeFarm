extends CanvasLayer

signal simulation_start
signal simulation_end

onready var AnimationPlayer := $AnimationPlayer
onready var GUI := $GUI
onready var SimulationToggleButton := $GUI/HBoxContainer/VBoxContainer/SimulationToggleButton

onready var SelectorContainer := $GUI/HBoxContainer/VBoxContainer/SelectorContainer
onready var TilesXSelector := $GUI/HBoxContainer/VBoxContainer/SelectorContainer/TilesXSelector
onready var TilesYSelector := $GUI/HBoxContainer/VBoxContainer/SelectorContainer/TilesYSelector
onready var PopSizeSelector := $GUI/HBoxContainer/VBoxContainer/SelectorContainer/PopSizeSelector
onready var NumFoodSelector := $GUI/HBoxContainer/VBoxContainer/SelectorContainer/NumFoodSelector
onready var MutProbSelector := $GUI/HBoxContainer/VBoxContainer/SelectorContainer/MutProbSelector

var toggled := true


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
	toggled = false
	AnimationPlayer.play("hide")
	
	
func show():
	toggled = true
	AnimationPlayer.play("show")


func disable_editing():
	for selector in SelectorContainer.get_children():
		selector.disable_editing()
	
	
func enable_editing():
	for selector in SelectorContainer.get_children():
		selector.enable_editing()


func start_simulation():
	hide()
	SimulationToggleButton.text = "End Simulation"
	disable_editing()
	emit_signal("simulation_start")


func end_simulation():
	SimulationToggleButton.text = "Start Simulation"
	enable_editing()
	emit_signal("simulation_end")


func _on_SimulationToggleButton_toggled(button_pressed):
	if button_pressed:
		start_simulation()
	else:
		end_simulation()
		

func _on_ToggleButton_pressed():
	if toggled:
		hide()
	else:
		show()
