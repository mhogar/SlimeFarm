extends "res://Scenes/UI/Sections/CollapsibleSection.gd"

onready var SimulationModeSelector := $Body/Selectors/SimulationModeSelector


func load_from_config():
	SimulationModeSelector.load_from_config()
