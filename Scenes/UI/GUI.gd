extends CanvasLayer

signal simulation_start
signal simulation_end
signal refresh

onready var AnimationPlayer := $AnimationPlayer

onready var FileDialog := $FileDialog
onready var ChooseDirLineEdit := $ConfigGUI/Panel/HBoxContainer/VBoxContainer/HBoxContainer/ChooseDirLineEdit
onready var ChooseDirButton := $ConfigGUI/Panel/HBoxContainer/VBoxContainer/HBoxContainer/ChooseDirButton

onready var IterationLabel := $ControlGUI/IterationLabel

onready var RefreshButton := $ConfigGUI/Panel/HBoxContainer/VBoxContainer/RefreshButton
onready var SimulationToggleButton := $ConfigGUI/Panel/HBoxContainer/VBoxContainer/SimulationToggleButton

onready var SelectorContainer := $ConfigGUI/Panel/HBoxContainer/VBoxContainer/SelectorContainer
onready var TilesXSelector := $ConfigGUI/Panel/HBoxContainer/VBoxContainer/SelectorContainer/TilesXSelector
onready var TilesYSelector := $ConfigGUI/Panel/HBoxContainer/VBoxContainer/SelectorContainer/TilesYSelector
onready var PopSizeSelector := $ConfigGUI/Panel/HBoxContainer/VBoxContainer/SelectorContainer/PopSizeSelector
onready var NumFoodSelector := $ConfigGUI/Panel/HBoxContainer/VBoxContainer/SelectorContainer/NumFoodSelector
onready var MutProbSelector := $ConfigGUI/Panel/HBoxContainer/VBoxContainer/SelectorContainer/MutProbSelector
onready var ScenarioSelector := $ConfigGUI/Panel/HBoxContainer/VBoxContainer/SelectorContainer/ScenarioSelector

var toggled := true


func _ready():
	load_from_config()
	update_iteration_counter(0)


func update_config():
	Config.num_tiles_x = TilesXSelector.get_value()
	Config.num_tiles_y = TilesYSelector.get_value()
	Config.population_size = PopSizeSelector.get_value()
	Config.num_food = NumFoodSelector.get_value()
	Config.mutation_probability = MutProbSelector.get_value()
	Config.csv_dir = ChooseDirLineEdit.text
	Config.scenario = ScenarioSelector.get_selected_scenario()
	Config.Scenario3.vision_radius = ScenarioSelector.Scenario3VisionRadiusValueSelector.get_value()
	Config.Scenario3.energy_consumption_rate = ScenarioSelector.Scenario3EnergyConsumptionRateSelector.get_value()


func load_from_config():
	TilesXSelector.set_value(Config.num_tiles_x)
	TilesYSelector.set_value(Config.num_tiles_y)
	PopSizeSelector.set_value(Config.population_size)
	NumFoodSelector.set_value(Config.num_food)
	MutProbSelector.set_value(Config.mutation_probability)
	ChooseDirLineEdit.text = Config.csv_dir
	ScenarioSelector.set_selected_scenario(Config.scenario)
	ScenarioSelector.Scenario3VisionRadiusValueSelector.set_value(Config.Scenario3.vision_radius)
	ScenarioSelector.Scenario3EnergyConsumptionRateSelector.set_value(Config.Scenario3.energy_consumption_rate)


func hide():
	toggled = false
	AnimationPlayer.play("hide")
	
	
func show():
	toggled = true
	AnimationPlayer.play("show")


func disable_editing():
	RefreshButton.disabled = true
	ChooseDirButton.disabled = true
	
	for selector in SelectorContainer.get_children():
		selector.disable_editing()
		
	
func enable_editing():
	RefreshButton.disabled = false
	ChooseDirButton.disabled = false
	
	for selector in SelectorContainer.get_children():
		selector.enable_editing()


func update_iteration_counter(iteration : int):
	IterationLabel.text = "Iteration: %d" % iteration


func start_simulation():
	hide()
	SimulationToggleButton.text = "End Simulation"
	disable_editing()
	load_from_config()
	emit_signal("simulation_start")


func end_simulation():
	update_iteration_counter(0)
	SimulationToggleButton.text = "Start Simulation"
	enable_editing()
	emit_signal("simulation_end")


func refresh():
	update_config()
	emit_signal("refresh")


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


func _on_RefreshButton_pressed():
	refresh()


func _on_ChooseDirButton_pressed():
	FileDialog.popup_centered()


func _on_FileDialog_dir_selected(dir):
	dir += "/"
	ChooseDirLineEdit.text = dir
	Config.csv_dir = dir


func _on_ScenarioSelector_scenario_changed():
	refresh()
