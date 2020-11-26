extends VBoxContainer

onready var DropDown := $HBoxContainer/DropDown

onready var Scenario3 := $Scenario3
onready var Scenario3Selectors := $Scenario3/Selectors
onready var Scenario3VisionRadiusValueSelector := $Scenario3/Selectors/VisionRadiusValueSelector
onready var Scenario3MaxEnergySelector := $Scenario3/Selectors/MaxEnergySelector
onready var Scenario3EnergyConsumptionModifierSelector := $Scenario3/Selectors/EnergyConsumptionModifierSelector
onready var Scenario3UpdateButton := $Scenario3/CenterContainer/UpdateButton

onready var Scenario1HelpDialog := $Scenario1HelpDialog
onready var Scenario2HelpDialog := $Scenario2HelpDialog
onready var Scenario3HelpDialog := $Scenario3HelpDialog


func _ready():
	DropDown.add_item("Scenario 1")
	DropDown.add_item("Scenario 2")
	DropDown.add_item("Scenario 3")
	
	change_visible_scenario(DropDown.selected)


func load_from_config():
	DropDown.selected = Config.scenario
	Scenario3VisionRadiusValueSelector.set_value(Config.scenario3_vision_radius)
	Scenario3MaxEnergySelector.set_value(Config.scenario3_max_energy)
	Scenario3EnergyConsumptionModifierSelector.set_value(Config.scenario3_energy_consumption_modifier)
	
	change_visible_scenario(DropDown.selected)
	

func disable_editing():
	DropDown.disabled = true
	
	Scenario3UpdateButton.disabled = true
	for child in Scenario3Selectors.get_children():
		child.disable_editing()
	
	
func enable_editing():
	DropDown.disabled = false
	
	Scenario3UpdateButton.disabled = false
	for child in Scenario3Selectors.get_children():
		child.enable_editing()


func change_visible_scenario(scenario : int):
	# hide all selectors
	Scenario3.hide()
	
	# show selectors specific to the selected scenario
	if scenario == Config.SCENARIO_3:
		Scenario3.show()


func scenario_changed():
	Config.scenario = DropDown.selected
	Config.scenario3_vision_radius = Scenario3VisionRadiusValueSelector.get_value()
	get_tree().call_group("config", "scenario_config_changed")


func _on_DropDown_item_selected(index):
	change_visible_scenario(index)
	scenario_changed()
	

func _on_Scenario3UpdateButton_pressed():
	scenario_changed()


func _on_HelpButton_pressed():
	match (DropDown.selected):
		Config.SCENARIO_2:
			Scenario2HelpDialog.popup_centered(Config.DIALOG_POPUP_SIZE_M)
		Config.SCENARIO_3:
			Scenario3HelpDialog.popup_centered(Config.DIALOG_POPUP_SIZE_M)
		_: # SCENARIO_1
			Scenario1HelpDialog.popup_centered(Config.DIALOG_POPUP_SIZE_M)


func _on_MaxEnergySelector_value_changed(value):
	Config.scenario3_max_energy = value
	
	
func _on_Scenario3EnergyConsumptionModifierSelector_value_changed(value):
	Config.scenario3_energy_consumption_modifier = value
