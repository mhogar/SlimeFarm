extends Node

var slimes := []


func initiaize(pop_size : int):
	var scene := load("res://Scenes/Actors/Slime.tscn")
	
	slimes.clear()
	for i in range(pop_size):
		var slime : Slime = scene.instance()
		
		slime.genes.append(randi() % 256) # speed
		slime.genes.append(randi() % 256) # vision radius
		
		# add slime to list
		slimes.append(slime)


func breed_slimes(mutation_prob : float):
	var pop_size := slimes.size()
	var slimes_copy := slimes.duplicate()
	
	var num_slimes := 0
	while num_slimes < pop_size:
		# select first parent
		var parent1 := select_parent_slime(slimes_copy)
		slimes_copy.erase(parent1)
		num_slimes += 1
		
		if num_slimes >= pop_size:
			break
		
		var parent2 := select_parent_slime(slimes_copy)
		slimes_copy.erase(parent2)
		num_slimes += 1
		
		if num_slimes >= pop_size:
			break
		
		# breed the parents and add the child to the list
		slimes.append(breed(parent1, parent2, mutation_prob))
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
	
	
func breed(slime1 : Slime, slime2: Slime, mutation_prob : float) -> Slime:
	var new_slime : Slime = load("res://Scenes/Actors/Slime.tscn").instance()
	
	# apply crossover to each gene
	for i in range(slime1.genes.size()):
		var cross_str := randi()
		var gene : int = (slime1.genes[i] & cross_str) + (slime2.genes[i] & (~cross_str))
		
		# apply mutation
		for j in range(8):
			if randf() <= mutation_prob:
				gene ^= (1 << j)
		
		new_slime.genes.append(gene)
	
	return new_slime
