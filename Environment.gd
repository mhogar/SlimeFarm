extends Node2D

export var time_scale := 1.0
export var env_width : int
export var env_height : int
export var pop_size : int
export var num_food : int
export var mutation_prob : float

onready var Slimes := $Slimes
onready var Food := $Food

var iteration := 0
var csv_file : File


func _ready():
	# seed the generator
	randomize()
	
	Engine.set_time_scale(time_scale)
	
	init_simulation()
	start_iteration()


func _exit_tree():
	csv_file.close()

func _physics_process(_delta : float):
	# check iteration is over
	if Food.get_child_count() == 0:
		end_iteration()


func init_simulation():
	create_slimes()
	create_csv()


func start_iteration():
	iteration += 1
	
	export_stats()
	setup_slimes()
	create_food()
	

func end_iteration():
	breed_slimes()
	start_iteration()
	

func create_csv():
	csv_file = File.new()
	csv_file.open("user://data_%d.csv" % OS.get_unix_time(), File.WRITE)
	csv_file.store_line("Iteration,Avg. Speed,Avg. Vision Radius")


func create_slimes():
	var scene := load("res://Slime.tscn")
	
	for i in range(pop_size):
		var slime : Slime = scene.instance()
		
		slime.genes.append(randi() % 256) # speed
		slime.genes.append(randi() % 256) # vision radius
		
		# add slime to list
		Slimes.add_child(slime)


func export_stats():
	# calc the data
	var data := PoolStringArray()
	data.append(String(iteration))
	data.append(String(calc_gene_avg(Slime.speed_gene_index)))
	data.append(String(calc_gene_avg(Slime.vision_radius_gene_index)))
	
	# write the data to the file
	csv_file.store_csv_line(data)


func calc_gene_avg(index : int) -> float:
	var total := 0
	for slime in Slimes.get_children():
		total += slime.genes[index]
	
	return float(total) / Slimes.get_child_count()


func setup_slimes():
	for slime in Slimes.get_children():
		slime.reset_stats()
		
		# choose random position
		slime.position.x = randf() * env_width
		slime.position.y = randf() * env_height
		
		# choose random starting face direction
		slime.init_face_dir.x = randf()
		slime.init_face_dir.y = randf()


func create_food():
	var scene := load("res://Food.tscn")
	
	var min_x := env_width * 0.1
	var min_y := env_height * 0.1
	
	for i in range(num_food):
		var food = scene.instance()
		
		# choose random position in inner box
		food.position.x = randf() * (env_width - 2 * min_x) + min_x
		food.position.y = randf() * (env_height - 2 * min_y) + min_y
		
		# add food to list
		Food.add_child(food)


func select_parent_slime(slimes : Array) -> Slime:
	# calc the total number of food collected by the slimes
	var total_food_collected := 0
	for slime in slimes:
		total_food_collected += slime.food_collected
	
	# if no food was collected, then choose a slime at random
	if total_food_collected == 0:
		return slimes[randi() % slimes.size()]
	
	# generate the random value
	var r := randf() * total_food_collected
	
	# select the slime with slimes who collected more food being more likely to be chosen
	var total := 0
	for slime in slimes:
		total += slime.food_collected
		if total >= r:
			return slime
	
	# this should in theory never be reached, but return the last slime just to be safe
	return slimes.back()


func breed_slimes():
	var slimes := Slimes.get_children().duplicate()
	
	var num_slimes := 0
	while num_slimes < pop_size:
		# select first parent
		var parent1 := select_parent_slime(slimes)
		slimes.erase(parent1)
		num_slimes += 1
		
		if num_slimes >= pop_size:
			break
		
		var parent2 := select_parent_slime(slimes)
		slimes.erase(parent2)
		num_slimes += 1
		
		if num_slimes >= pop_size:
			break
		
		# breed the parents and add the child to the scene
		Slimes.add_child(parent1.breed(parent2))
		num_slimes += 1

	# remove any slimes that did not breed from the scene
	for slime in slimes:
		slime.queue_free()
