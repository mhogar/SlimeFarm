extends VBoxContainer

signal scenario_changed

onready var DropDown := $HBoxContainer/DropDown

onready var Scenario3 := $Scenario3
onready var Scenario3VisionRadiusValueSelector := $Scenario3/VisionRadiusValueSelector
onready var Scenario3EnergyConsumptionRateSelector := $Scenario3/EnergyConsumptionRateSelector

onready var Scenario1InfoDialog := $Scenario1InfoDialog
onready var Scenario2InfoDialog := $Scenario2InfoDialog
onready var Scenario3InfoDialog := $Scenario3InfoDialog

const info_dialog_size := Vector2(500, 300)


func _ready():
	DropDown.add_item("Scenario 1")
	DropDown.add_item("Scenario 2")
	DropDown.add_item("Scenario 3")
	
	scenario_selection_changed(DropDown.selected)


func get_selected_scenario() -> int:
	return DropDown.selected


func set_selected_scenario(scenario : int):
	DropDown.select(scenario)
	scenario_selection_changed(DropDown.selected)


func scenario_selection_changed(scenario : int):
	# hide all selectors
	Scenario3.hide()
	
	# show selectors specific to the selected scenario
	if scenario == Config.SCENARIO_3:
		Scenario3.show()


func disable_editing():
	DropDown.disabled = true
	Scenario3VisionRadiusValueSelector.disable_editing()
	Scenario3EnergyConsumptionRateSelector.disable_editing()
	
	
func enable_editing():
	DropDown.disabled = false
	Scenario3VisionRadiusValueSelector.enable_editing()
	Scenario3EnergyConsumptionRateSelector.enable_editing()


func _on_DropDown_item_selected(index):
	scenario_selection_changed(index)
	emit_signal("scenario_changed")


func _on_InfoButton_pressed():	
	if DropDown.selected == Config.SCENARIO_2:
		Scenario2InfoDialog.popup_centered(info_dialog_size)
	elif DropDown.selected == Config.SCENARIO_3:
		Scenario3InfoDialog.popup_centered(info_dialog_size)
	else: # SCENARIO_1
		Scenario1InfoDialog.popup_centered(info_dialog_size)
