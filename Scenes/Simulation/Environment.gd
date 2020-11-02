extends TileMap

	
func initialize(num_tiles_x : int, num_tiles_y : int):
	clear()
	
	for x in range(num_tiles_x):
		for y in range(num_tiles_y):
			set_cell(x, y, 0)
