extends "res://Scenes/UI/ConfigUI/Sections/CollapsibleSection.gd"

onready var MutProbSelector := $Body/Selectors/MutProbSelector


func load_from_config():
	MutProbSelector.set_value(Config.mutation_probability)


func _on_MutProbSelector_value_changed(value):	
	Config.mutation_probability = value
