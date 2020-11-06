extends Node

var num_tiles_x : int = 20
var num_tiles_y : int = 20
var population_size : int = 6
var num_food : int = 10
var mutation_probability : float = 0.01
var csv_dir : String = ""


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
		
	num_tiles_x = config.get_value("", "num_tiles_x")
	num_tiles_y = config.get_value("", "num_tiles_y")
	population_size = config.get_value("", "population_size")
	num_food = config.get_value("", "num_food")
	mutation_probability = config.get_value("", "mutation_probability")
	csv_dir = config.get_value("", "csv_dir")
	
	
func save_config():
	var config := ConfigFile.new()
	
	config.set_value("", "num_tiles_x", num_tiles_x)
	config.set_value("", "num_tiles_y", num_tiles_y)
	config.set_value("", "population_size", population_size)
	config.set_value("", "num_food", num_food)
	config.set_value("", "mutation_probability", mutation_probability)
	config.set_value("", "csv_dir", csv_dir)
	
	config.save("user://settings.cfg")
