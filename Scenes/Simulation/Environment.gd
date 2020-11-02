extends TileMap

func _ready():
	rebuild()
	
func rebuild():
	clear()
	
	for x in range(Config.num_tiles_x):
		for y in range(Config.num_tiles_y):
			set_cell(x, y, 0)
