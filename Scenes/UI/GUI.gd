extends CanvasLayer

signal simulation_start
signal simulation_end

onready var AnimationPlayer := $AnimationPlayer
onready var IterationLabel := $ControlGUI/VBoxContainer/IterationLabel
onready var TrialLabel := $ControlGUI/VBoxContainer/TrialLabel
onready var SimulationToggleButton := $ConfigGUI/Panel/HBoxContainer/ScrollContainer/VBoxContainer/SimulationToggleButton
onready var SectionsContainer := $ConfigGUI/Panel/HBoxContainer/ScrollContainer/VBoxContainer/SectionsContainer

var toggled := true


func _ready():
	get_tree().call_group("config", "config_loaded")
	load_from_config()
	
	update_iteration_counter(0)
	update_trial_counter(0)
	
	
func load_from_config():
	for section in SectionsContainer.get_children():
		section.load_from_config()
	

func hide():
	if !toggled:
		return
	
	toggled = false
	AnimationPlayer.play("hide")
	
	
func show():
	if toggled:
		return
	
	toggled = true
	AnimationPlayer.play("show")


func disable_editing():
	for section in SectionsContainer.get_children():
		section.disable_editing()
		
	
func enable_editing():
	for section in SectionsContainer.get_children():
		section.enable_editing()


func update_iteration_counter(iteration : int):
	IterationLabel.text = "Iteration: %d" % iteration


func update_trial_counter(trial : int):
	TrialLabel.text = "Trial: %d" % trial


func start_simulation():
	hide()
	disable_editing()
	SimulationToggleButton.pressed = true
	SimulationToggleButton.text = "End Simulation"
	load_from_config()


func end_simulation():
	SimulationToggleButton.pressed = false
	update_iteration_counter(0)
	update_trial_counter(0)
	SimulationToggleButton.text = "Start Simulation"
	enable_editing()
	show()


func _on_SimulationToggleButton_toggled(button_pressed):
	if button_pressed:
		start_simulation()
		emit_signal("simulation_start")
	else:
		end_simulation()
		emit_signal("simulation_end")
		

func _on_ToggleButton_pressed():
	if toggled:
		hide()
	else:
		show()


func _on_UserManualButton_pressed():
	OS.shell_open("https://github.com/mhogar/SlimeFarm/wiki/User-Manual")
