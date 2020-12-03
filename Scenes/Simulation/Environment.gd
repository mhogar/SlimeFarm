extends TileMap

const TILE_PROB := [0.85, 0.05, 0.05, 0.05]


func rebuild():
	clear()
	
	for x in range(Config.num_tiles_x):
		for y in range(Config.num_tiles_y):
			set_cell(x, y, Config.env_setting, false, false, false, Vector2(select_tile(), 0))


func select_tile() -> int:
	var r := randf()
	
	var sum := 0.0
	for i in range(TILE_PROB.size()):
		sum += TILE_PROB[i]
		if sum >= r:
			return i
	
	return 0
