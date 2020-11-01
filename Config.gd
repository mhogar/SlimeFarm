extends Node

const tile_size : int = 32
var num_tiles_x : int = 32
var num_tiles_y : int = 20


func get_env_width() -> int:
	return num_tiles_x * tile_size
	

func get_env_height() -> int:
	return num_tiles_y * tile_size
