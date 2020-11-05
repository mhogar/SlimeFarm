extends Node

var num_tiles_x : int
var num_tiles_y : int
var population_size :int
var num_food : int
var mutation_probability : float


func calc_env_width() -> int:
	return num_tiles_x * 32
	

func calc_env_height() -> int:
	return num_tiles_y * 32
