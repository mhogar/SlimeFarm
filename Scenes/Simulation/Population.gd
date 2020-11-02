extends Node

var slimes := []


func initiaize():
	create_slimes()


func create_slimes():
	var scene := load("res://Scenes/Actors/Slime.tscn")
	
	for i in range(Config.pop_size):
		var slime : Slime = scene.instance()
		
		slime.genes.append(randi() % 256) # speed
		slime.genes.append(randi() % 256) # vision radius
		
		# add slime to list
		slimes.append(slime)


func breed_slimes():
	var slimes_copy := slimes.duplicate()
	
	var num_slimes := 0
	while num_slimes < Config.pop_size:
		# select first parent
		var parent1 := select_parent_slime(slimes_copy)
		slimes_copy.erase(parent1)
		num_slimes += 1
		
		if num_slimes >= Config.pop_size:
			break
		
		var parent2 := select_parent_slime(slimes_copy)
		slimes_copy.erase(parent2)
		num_slimes += 1
		
		if num_slimes >= Config.pop_size:
			break
		
		# breed the parents and add the child to the list
		slimes.append(parent1.breed(parent2))
		num_slimes += 1

	# remove any slimes that did not breed from the list
	for slime in slimes_copy:
		slimes.erase(slime)


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
