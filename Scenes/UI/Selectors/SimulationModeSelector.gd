extends VBoxContainer

onready var DropDown := $HBoxContainer/DropDown
onready var Finite := $Finite
onready var FiniteTrialLengthValueSelector := $Finite/TrialLengthValueSelector
onready var FiniteNumTrialsValueSelector := $Finite/NumTrialsValueSelector
onready var HelpDialog := $HelpDialog


func _ready():
	DropDown.add_item("Infinite")
	DropDown.add_item("Finite")
	
	change_visible_simulation_mode(DropDown.selected)


func load_from_config():
	DropDown.selected = Config.iteration_type
	FiniteTrialLengthValueSelector.set_value(Config.iteration_type_finite_trial_length)
	FiniteNumTrialsValueSelector.set_value(Config.iteration_type_finite_num_trials)

	change_visible_simulation_mode(DropDown.selected)


func disable_editing():
	DropDown.disabled = true
	for child in Finite.get_children():
		child.disable_editing()
	
	
func enable_editing():
	DropDown.disabled = false
	for child in Finite.get_children():
		child.enable_editing()


func change_visible_simulation_mode(mode : int):
	# hide all selectors
	Finite.hide()
	
	# show selectors specific to the selected mode
	if mode == Config.ITERATION_TYPE_FINITE:
		Finite.show()


func _on_DropDown_item_selected(index):
	change_visible_simulation_mode(index)
	Config.iteration_type = DropDown.selected


func _on_FiniteTrialLengthValueSelector_value_changed(value):
	Config.iteration_type_finite_trial_length = value


func _on_FiniteNumTrialsValueSelector_value_changed(value):
	Config.iteration_type_finite_num_trials = value


func _on_HelpButton_pressed():
	HelpDialog.popup_centered(Config.DIALOG_POPUP_SIZE_M)
