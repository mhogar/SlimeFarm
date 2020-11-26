extends VBoxContainer

onready var DropDown := $HBoxContainer/DropDown

onready var Finite := $Finite
onready var FiniteIterationLengthSelector := $Finite/IterationLengthValueSelector
onready var FiniteNumTrialsValueSelector := $Finite/NumTrialsValueSelector


func _ready():
	DropDown.add_item("Infinite")
	DropDown.add_item("Finite")
	
	change_visible_simulation_mode(DropDown.selected)


func load_from_config():
	DropDown.selected = Config.iteration_type
	FiniteIterationLengthSelector.set_value(Config.iteration_type_finite_iteration_length)
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


func _on_FiniteIterationLengthValueSelector_value_changed(value):
	Config.iteration_type_finite_iteration_length = value


func _on_FiniteNumTrialsValueSelector_value_changed(value):
	Config.iteration_type_finite_num_trials = value
