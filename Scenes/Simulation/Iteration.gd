extends Node

signal finished

onready var Slimes := $Slimes
onready var Food := $Food

var env_width : int
var env_height : int
var slimes : Array
var num_food : int

var timer : float
var stats : Array


func _physics_process(delta):
	timer += delta
	
	if Food.get_child_count() == 0:
		end_iteration()


func initialize(env_width : int, env_height : int, slimes : Array, num_food : int):
	self.env_width = env_width
	self.env_height = env_height
	self.slimes = slimes
	self.num_food = num_food


func start_new():
	timer = 0.0
	setup_slimes()
	create_food()


func setup_slimes():
	for slime in slimes:
		# choose random position
		slime.position.x = randf() * env_width
		slime.position.y = randf() * env_height
		
		# choose random starting face direction
		slime.init_face_dir.x = randf()
		slime.init_face_dir.y = randf()
		
		# add to the scene tree
		Slimes.add_child(slime)


func create_food():
	var scene := load("res://Scenes/Actors/Food.tscn")
	
	var min_x := env_width * 0.1
	var min_y := env_height * 0.1
	
	for i in range(num_food):
		var food = scene.instance()
		
		# choose random position in inner box
		food.position.x = randf() * (env_width - 2 * min_x) + min_x
		food.position.y = randf() * (env_height - 2 * min_y) + min_y
		
		# add food to list
		Food.add_child(food)


func end_iteration():
	calc_stats()
	remove_slimes()
	emit_signal("finished")
	
	
func calc_stats():
	stats = []
	stats.append(timer)
	stats.append(calc_gene_avg(Slime.speed_gene_index))
	stats.append(calc_gene_avg(Slime.vision_radius_gene_index))


func calc_gene_avg(index : int) -> float:
	var total := 0
	for slime in Slimes.get_children():
		total += slime.genes[index]
	
	return float(total) / Slimes.get_child_count()
	
	
func remove_slimes():
	for child in Slimes.get_children():
		Slimes.remove_child(child)
