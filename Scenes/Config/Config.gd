extends Node

enum {SETTING_MEADOW, SETTING_DESERT}
enum {SCENARIO_1, SCENARIO_2, SCENARIO_3}
enum {ITERATION_TYPE_INFINITE, ITERATION_TYPE_FINITE}

const TILE_SIZE : int = 64
const TILES_PER_SETTING : int = 4
const DIALOG_POPUP_SIZE_S := Vector2(300, 100)
const DIALOG_POPUP_SIZE_M := Vector2(500, 300)
const DIALOG_POPUP_SIZE_L := Vector2(800, 600)

var csv_dir : String = ""

var env_setting : int = SETTING_MEADOW

var num_tiles_x : int = 10
var num_tiles_y : int = 10
var population_size : int = 6
var num_food : int = 10

var mutation_probability : float = 0.01

var scenario : int = SCENARIO_1
var scenario3_vision_radius : int = 127
var scenario3_max_energy : int = 500
var scenario3_energy_consumption_modifier : float = 2.0

var iteration_type : int = ITERATION_TYPE_INFINITE
var iteration_type_finite_trial_length : int = 5
var iteration_type_finite_num_trials : int = 1


func _ready():
	load_config()
	

func _exit_tree():
	save_config()


func calc_env_width() -> int:
	return num_tiles_x * TILE_SIZE
	

func calc_env_height() -> int:
	return num_tiles_y * TILE_SIZE
	

func load_config():
	var config := ConfigFile.new()
	if config.load("user://settings.cfg") != OK:
		return
		
	env_setting = config.get_value("environment", "env_setting", env_setting)
	num_tiles_x = config.get_value("environment", "num_tiles_x", num_tiles_x)
	num_tiles_y = config.get_value("environment", "num_tiles_y", num_tiles_y)
	population_size = config.get_value("environment", "population_size", population_size)
	num_food = config.get_value("environment", "num_food", num_food)
	
	mutation_probability = config.get_value("genetic_algorithm", "mutation_probability", mutation_probability)
	
	scenario = config.get_value("scenario", "scenario", scenario)
	scenario3_vision_radius = config.get_value("scenario3", "vision_radius", scenario3_vision_radius)
	scenario3_max_energy = config.get_value("scenario3", "max_energy", scenario3_max_energy)
	scenario3_energy_consumption_modifier = config.get_value("scenario3", "energy_consumption_modifier", scenario3_energy_consumption_modifier)
	
	iteration_type = config.get_value("iteration_type", "type", iteration_type)
	iteration_type_finite_trial_length = config.get_value("iteration_type_finite", "trial_length", iteration_type_finite_trial_length)
	iteration_type_finite_num_trials = config.get_value("iteration_type_finite", "num_trials", iteration_type_finite_num_trials)
	
	csv_dir = config.get_value("misc", "csv_dir", csv_dir)
	
	
func save_config():
	var config := ConfigFile.new()
	
	config.set_value("environment", "env_setting", env_setting)
	config.set_value("environment", "num_tiles_x", num_tiles_x)
	config.set_value("environment", "num_tiles_y", num_tiles_y)
	config.set_value("environment", "population_size", population_size)
	config.set_value("environment", "num_food", num_food)
	
	config.set_value("genetic_algorithm", "mutation_probability", mutation_probability)
	
	config.set_value("scenario", "scenario", scenario)
	config.set_value("scenario3", "vision_radius", scenario3_vision_radius)
	config.set_value("scenario3", "max_energy", scenario3_max_energy)
	config.set_value("scenario3", "energy_consumption_modifier", scenario3_energy_consumption_modifier)
	
	config.set_value("iteration_type", "type", iteration_type)
	config.set_value("iteration_type_finite", "trial_length", iteration_type_finite_trial_length)
	config.set_value("iteration_type_finite", "num_trials", iteration_type_finite_num_trials)
	
	config.set_value("misc", "csv_dir", csv_dir)
	
	config.save("user://settings.cfg")
