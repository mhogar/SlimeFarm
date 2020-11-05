extends Node2D

onready var ConfigUI := $SimulationConfig
onready var Environment := $Environment
onready var Camera := $Camera
onready var Iteration := $Iteration
onready var Population := $Population

const max_time_scale := 8.0
const min_time_scale := 1.0

var simulation_running : bool
var iteration : int
var csv_file : File


func _ready():
	# seed the generator
	randomize()
	
	pause_simulation()
	

func _exit_tree():
	close_csv()


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


func start_simulation():
	# calc the environment's dimensions
	var env_width : int = ConfigUI.get_num_tiles_x() * Environment.cell_size.x
	var env_height : int = ConfigUI.get_num_tiles_y() * Environment.cell_size.y
	
	# initialize the scenes
	Environment.initialize(ConfigUI.get_num_tiles_x(), ConfigUI.get_num_tiles_y())
	Camera.initialize(env_width, env_height)
	Population.initiaize(ConfigUI.get_population_size())
	Iteration.initialize(env_width, env_height, Population.slimes, ConfigUI.get_num_food())
	
	# set default control values
	Engine.set_time_scale(min_time_scale)
	
	# create the stats file
	create_csv()
	
	# start the first iteration
	iteration = 1
	Iteration.start_new()
	play_simulation()


func create_csv():
	csv_file = File.new()
	csv_file.open("user://data_%d.csv" % OS.get_unix_time(), File.WRITE)
	csv_file.store_line("Iteration,Time (s),Avg. Speed,Avg. Vision Radius")
	
	
func close_csv():	
	if csv_file != null:
		csv_file.close()
		
	
func export_stats():
	var data := PoolStringArray([iteration])
	#data.append(String(iteration))
	data.append_array(PoolStringArray(Iteration.stats))
	
	csv_file.store_csv_line(data)


func _on_SimulationConfig_simulation_start():
	start_simulation()


func _on_SimulationConfig_simulation_end():
	pause_simulation()
	Iteration.abort()
	close_csv()


func _on_Iteration_finished():
	export_stats()
	
	iteration += 1
	Population.breed_slimes(ConfigUI.get_mutation_probability())
	Iteration.start_new()
