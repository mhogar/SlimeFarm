extends VBoxContainer

onready var DropDown := $HBoxContainer/DropDown

onready var Finite := $Finite
onready var FiniteNumSimulationSelector := $Finite/NumSimulationsValueSelector
onready var FiniteIterationLengthSelector := $Finite/IterationLengthValueSelector


func _ready():
	DropDown.add_item("Infinite")
	DropDown.add_item("Finite")
	
	iteration_type_selection_changed(DropDown.selected)


func get_selected_iteration_type() -> int:
	return DropDown.selected


func set_selected_iteration_type(type : int):
	DropDown.select(type)
	iteration_type_selection_changed(DropDown.selected)


func iteration_type_selection_changed(type : int):
	# hide all selectors
	Finite.hide()
	
	# show selectors specific to the selected type
	if type == Config.ITERATION_TYPE_FINITE:
		Finite.show()


func disable_editing():
	DropDown.disabled = true
	FiniteNumSimulationSelector.disable_editing()
	FiniteIterationLengthSelector.disable_editing()
	
	
func enable_editing():
	DropDown.disabled = false
	FiniteNumSimulationSelector.enable_editing()
	FiniteIterationLengthSelector.enable_editing()


func _on_DropDown_item_selected(id):
	iteration_type_selection_changed(id)
