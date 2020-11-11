extends Node

signal finished

onready var Slimes := $Slimes
onready var Food := $Food

const env_margin : int = 1

var slimes : Array
var timer : float
var stats : Array


func _physics_process(delta):
	timer += delta
	
	if Food.get_child_count() == 0:
		end_iteration()
	

func create_new(slimes : Array):
	self.slimes = slimes
	reset()
	
	setup_slimes()
	create_food()


func setup_slimes():
	for slime in slimes:
		# choose random starting face direction
		slime.init_face_dir.x = randf()
		slime.init_face_dir.y = randf()
		
		# add to the scene tree
		Slimes.add_child(slime)
		
	place_actors(slimes)


func create_food():
	var scene := load("res://Scenes/Actors/Food.tscn")
	
	for i in range(Config.num_food):
		Food.add_child(scene.instance())

	place_actors(Food.get_children())


func place_actors(actors : Array):
	var num_tiles_x := Config.num_tiles_x - env_margin * 2
	var num_tiles_y := Config.num_tiles_y - env_margin * 2
	
	# create array with entry for every tile
	var tiles := range(num_tiles_x * num_tiles_y)
	var tile_ptr := tiles.size()
	
	for actor in actors:
		# if out of tiles, reshuffle and start again
		if tile_ptr >= tiles.size():
			tiles.shuffle()
			tile_ptr = 0
		
		# select the next tile index and convert it to 2d coords 
		var index : int = tiles[tile_ptr]
		tile_ptr += 1
		var x_coord := index % num_tiles_x + env_margin
		var y_coord := index / num_tiles_x + env_margin
		
		# place the entity randomly in the tile
		actor.position.x = x_coord * Config.TILE_SIZE + randf() * (Config.TILE_SIZE)
		actor.position.y = y_coord * Config.TILE_SIZE + randf() * (Config.TILE_SIZE)
		

func reset():
	timer = 0.0
	
	for slime in Slimes.get_children():
		slime.queue_free()
		
	for food in Food.get_children():
		food.queue_free()
	

func end_iteration():	
	calc_stats()
	remove_slimes()
	emit_signal("finished")

	
func calc_stats():
	stats = []
	stats.append(timer)
	stats.append(calc_gene_avg(Slime.SPEED_GENE_INDEX))
	stats.append(calc_gene_avg(Slime.VISION_RADIUS_GENE_INDEX))


func calc_gene_avg(index : int) -> float:
	var total := 0
	for slime in slimes:
		total += slime.genes[index]
	
	return float(total) / slimes.size()
	
	
func remove_slimes():
	for child in Slimes.get_children():
		Slimes.remove_child(child)
