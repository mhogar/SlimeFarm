extends Node2D

export var env_width : int
export var env_height : int
export var pop_size : int
export var num_food : int

onready var Slimes := $Slimes
onready var Food := $Food

var interation := 0


func _ready():
	# seed the generator
	randomize()
	
	init_simulation()
	start_iteration()


func _process(_delta : float):
	# check iteration is over
	if Food.get_child_count() == 0:
		end_iteration()


func init_simulation():
	create_slimes()


func start_iteration():
	interation += 1
	
	setup_slimes()
	create_food()
	

func end_iteration():
	breed_slimes()
	start_iteration()
	

func create_slimes():
	var scene := load("res://Slime.tscn")
	
	for i in range(pop_size):
		var slime : Slime = scene.instance()
		
		slime.genes.append(randi() % 256) # speed
		slime.genes.append(randi() % 256) # vision radius
		
		# add slime to list
		Slimes.add_child(slime)


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
	
	for i in range(num_food):
		var food = scene.instance()
		
		# choose random position
		food.position.x = randf() * env_width
		food.position.y = randf() * env_height
		
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
