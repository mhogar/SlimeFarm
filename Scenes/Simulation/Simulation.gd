extends Node2D

onready var GUI := $GUI
onready var Environment := $Environment
onready var Camera := $Camera
onready var Iteration := $Iteration
onready var Population := $Population

const max_time_scale := 8.0
const min_time_scale := 1.0

var simulation_running : bool
var iteration : int

var csv_filepath : String
var csv_file : File


func _ready():
	# seed the generator
	randomize()
	
	pause_simulation()
	refresh()


func _process(_delta):
	# inputs after this line will not be checked when the simulation is not running
	if !simulation_running:
		return
	
	if Input.is_action_just_pressed("speed_up") && Engine.time_scale < max_time_scale:
		Engine.time_scale *= 2.0
		get_tree().paused = false
	elif Input.is_action_just_pressed("slow_down") && Engine.time_scale > min_time_scale:
		Engine.time_scale /= 2.0
		get_tree().paused = false
		
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = !get_tree().paused


func play_simulation():
	simulation_running = true
	get_tree().paused = false
	

func pause_simulation():
	simulation_running = false
	get_tree().paused = true


func refresh():
	Environment.rebuild()
	Camera.center()
	Population.generate()
	Iteration.create_new(Population.slimes)


func start_simulation():
	Engine.set_time_scale(min_time_scale)
	create_csv()
	
	# start the first iteration
	iteration = 1
	GUI.update_iteration_counter(iteration)
	play_simulation()


func end_simulation():
	pause_simulation()
	refresh()
	

func create_csv():
	var csv_dir := Config.csv_dir
	if csv_dir == "":
		csv_dir = "user://"
	
	# create the file
	csv_filepath = csv_dir + "stats_%d.csv" % OS.get_unix_time()
	csv_file = File.new()
	csv_file.open(csv_filepath, File.WRITE)
	
	var config_header := "Num Tiles X,Num Tiles Y,Population Size,Num Food,Mutation Probability,Scenario"
	var config_values := [Config.num_tiles_x, Config.num_tiles_y, Config.population_size, Config.num_food, Config.mutation_probability, Config.scenario + 1]
	
	# update the config header and values based on the scenario
	if Config.scenario == Config.SCENARIO_3:
		config_header += ",Vision Radius,Max Energy,Energy Consumption Modifer"
		config_values.append(Config.scenario3_vision_radius)
		config_values.append(Config.scenario3_max_energy)
		config_values.append(Config.scenario3_energy_consumption_modifier)
	
	#store the data
	csv_file.store_line(config_header)
	csv_file.store_csv_line(PoolStringArray(config_values))
	csv_file.store_line("")
	csv_file.store_line("Iteration,Time (s),Avg. Speed,Avg. Vision Radius,Speed Range,Vision Radius Range")
	
	# close the file
	csv_file.close()
	
	
func export_stats():
	var data := PoolStringArray([iteration])
	data.append_array(PoolStringArray(Iteration.stats))
	
	csv_file.open(csv_filepath, File.READ_WRITE)
	csv_file.seek_end()
	csv_file.store_csv_line(data)
	csv_file.close()

	
func _on_Iteration_finished():
	export_stats()
	
	iteration += 1
	GUI.update_iteration_counter(iteration)
	
	Population.breed_slimes()
	Iteration.create_new(Population.slimes)


func _on_SimulationConfigUI_simulation_start():
	start_simulation()


func _on_SimulationConfigUI_simulation_end():
	end_simulation()


func _on_SimulationConfigUI_refresh():
	refresh()
