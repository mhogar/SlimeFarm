extends TileMap


func rebuild():
	clear()
	
	for x in range(Config.num_tiles_x):
		for y in range(Config.num_tiles_y):
			set_cell(x, y, Config.setting, false, false, false, Vector2(select_tile(), 0))


func select_tile() -> int:
	var prob := [0.85, 0.05, 0.05, 0.05]
	
	var r := randf()
	
	var sum := 0.0
	for i in range(prob.size()):
		sum += prob[i]
		if sum >= r:
			return i
	
	return 0
