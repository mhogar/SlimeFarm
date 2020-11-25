extends Node

signal finished

onready var Slimes := $Slimes
onready var Food := $Food

export var padding : float
export var num_chunks : int

var slimes : Array
var timer : float
var stats : Array


func _physics_process(delta):
	timer += delta
	
	if Food.get_child_count() == 0 || Slimes.get_child_count() == 0:
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
		slime.reset()
		
	place_actors(slimes)


func create_food():
	var scene := load("res://Scenes/Actors/Food.tscn")
	
	for i in range(Config.num_food):
		Food.add_child(scene.instance())

	place_actors(Food.get_children())


func place_actors(actors : Array):
	var chunk_size_x = Config.calc_env_width() / float(num_chunks)
	var chunk_size_y = Config.calc_env_height() / float(num_chunks)
	
	var chunk_padding_x = chunk_size_x * padding
	var chunk_padding_y = chunk_size_y * padding
	
	# create array with entry for every tile
	var tiles := range(num_chunks * num_chunks)
	var tile_ptr := tiles.size()
	
	for actor in actors:
		# if out of tiles, reshuffle and start again
		if tile_ptr >= tiles.size():
			tiles.shuffle()
			tile_ptr = 0
		
		# select the next tile index and convert it to 2d coords 
		var index : int = tiles[tile_ptr]
		tile_ptr += 1
		var x_coord := index % num_chunks
		var y_coord := index / num_chunks
		
		# place the entity randomly in the tile
		actor.position.x = x_coord * chunk_size_x + randf() * (chunk_size_x - chunk_padding_x * 2) + chunk_padding_x
		actor.position.y = y_coord * chunk_size_y + randf() * (chunk_size_y - chunk_padding_y * 2) + chunk_padding_y
		

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
	stats = [timer]
	
	# calc speed gene stats
	var speed_stats := calc_gene_stats(Slime.SPEED_GENE_INDEX)
	for stat in speed_stats:
		stats.append(stat)
	
	# calc vision radius gene stats
	var vision_radius_stats := calc_gene_stats(Slime.VISION_RADIUS_GENE_INDEX)
	for stat in vision_radius_stats:
		stats.append(stat)


func calc_gene_stats(index : int) -> Array:
	var min_val := Slime.MAX_GENE_VALUE
	var max_val := 0
	var total := 0
	
	for slime in slimes:
		var val : int = slime.genes[index]
		total += val
		
		if val < min_val:
			min_val = val
		elif val > max_val:
			max_val = val
	
	return [float(total) / slimes.size(), min_val, max_val];
	
	
func remove_slimes():
	for slime in Slimes.get_children():
		Slimes.remove_child(slime)
