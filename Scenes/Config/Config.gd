extends Node

enum {SCENARIO_1, SCENARIO_2, SCENARIO_3}

var csv_dir : String = ""

var num_tiles_x : int = 20
var num_tiles_y : int = 20
var population_size : int = 6
var num_food : int = 10

var mutation_probability : float = 0.01

var scenario : int = SCENARIO_1
var scenario3_vision_radius : int = 127
var scenario3_energy_consumption_rate : float = 0.5


func _ready():
	load_config()
	

func _exit_tree():
	save_config()


func calc_env_width() -> int:
	return num_tiles_x * 32
	

func calc_env_height() -> int:
	return num_tiles_y * 32
	

func load_config():
	var config := ConfigFile.new()
	var err := config.load("user://settings.cfg")
	if err != OK:
		return
		
	csv_dir = config.get_value("general", "csv_dir")
	num_tiles_x = config.get_value("environment", "num_tiles_x")
	num_tiles_y = config.get_value("environment", "num_tiles_y")
	population_size = config.get_value("environment", "population_size")
	num_food = config.get_value("environment", "num_food")
	mutation_probability = config.get_value("genetic_algorithm", "mutation_probability")
	scenario = config.get_value("scenario", "scenario")
	scenario3_vision_radius = config.get_value("scenario3", "vision_radius")
	scenario3_energy_consumption_rate = config.get_value("scenario3", "energy_consumption_rate")
	
	
func save_config():
	var config := ConfigFile.new()
	
	config.set_value("general", "csv_dir", csv_dir)
	config.set_value("environment", "num_tiles_x", num_tiles_x)
	config.set_value("environment", "num_tiles_y", num_tiles_y)
	config.set_value("environment", "population_size", population_size)
	config.set_value("environment", "num_food", num_food)
	config.set_value("genetic_algorithm", "mutation_probability", mutation_probability)
	config.set_value("scenario", "scenario", scenario)
	config.set_value("scenario3", "vision_radius", scenario3_vision_radius)
	config.set_value("scenario3", "energy_consumption_rate", scenario3_energy_consumption_rate)
	
	config.save("user://settings.cfg")
