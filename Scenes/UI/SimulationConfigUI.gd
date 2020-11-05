extends CanvasLayer

signal simulation_start
signal simulation_end
signal refresh

onready var AnimationPlayer := $AnimationPlayer

onready var RefreshButton := $GUI/Panel/HBoxContainer/VBoxContainer/RefreshButton
onready var SimulationToggleButton := $GUI/Panel/HBoxContainer/VBoxContainer/SimulationToggleButton

onready var SelectorContainer := $GUI/Panel/HBoxContainer/VBoxContainer/SelectorContainer
onready var TilesXSelector := $GUI/Panel/HBoxContainer/VBoxContainer/SelectorContainer/TilesXSelector
onready var TilesYSelector := $GUI/Panel/HBoxContainer/VBoxContainer/SelectorContainer/TilesYSelector
onready var PopSizeSelector := $GUI/Panel/HBoxContainer/VBoxContainer/SelectorContainer/PopSizeSelector
onready var NumFoodSelector := $GUI/Panel/HBoxContainer/VBoxContainer/SelectorContainer/NumFoodSelector
onready var MutProbSelector := $GUI/Panel/HBoxContainer/VBoxContainer/SelectorContainer/MutProbSelector

var toggled := true


func _ready():
	update_config()


func update_config():
	Config.num_tiles_x = TilesXSelector.get_value()
	Config.num_tiles_y = TilesYSelector.get_value()
	Config.population_size = PopSizeSelector.get_value()
	Config.num_food = NumFoodSelector.get_value()
	Config.mutation_probability = MutProbSelector.get_value()


func revert_to_config():
	TilesXSelector.set_value(Config.num_tiles_x)
	TilesYSelector.set_value(Config.num_tiles_y)
	PopSizeSelector.set_value(Config.population_size)
	NumFoodSelector.set_value(Config.num_food)
	MutProbSelector.set_value(Config.mutation_probability)


func hide():
	toggled = false
	AnimationPlayer.play("hide")
	
	
func show():
	toggled = true
	AnimationPlayer.play("show")


func disable_editing():
	RefreshButton.disabled = true
	for selector in SelectorContainer.get_children():
		selector.disable_editing()
		
	
func enable_editing():
	RefreshButton.disabled = false
	for selector in SelectorContainer.get_children():
		selector.enable_editing()


func start_simulation():
	hide()
	SimulationToggleButton.text = "End Simulation"
	disable_editing()
	revert_to_config()
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


func _on_RefreshButton_pressed():
	update_config()
	emit_signal("refresh")
