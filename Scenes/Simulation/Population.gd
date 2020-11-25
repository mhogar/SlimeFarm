extends Node

var slimes := []


func generate():
	var scene := load("res://Scenes/Actors/Slime.tscn")
	
	slimes.clear()
	for i in range(Config.population_size):
		var slime : Slime = scene.instance()
		
		match (Config.scenario):
			Config.SCENARIO_2:
				# give random value to speed gene
				var gene := randi() % (Slime.MAX_GENE_VALUE + 1)
				slime.genes.append(gene)
				
				# calc vision radius based on speed
				slime.genes.append(Slime.MAX_GENE_VALUE - gene)
				
			Config.SCENARIO_3:
				# give random value to speed gene
				slime.genes.append(randi() % (Slime.MAX_GENE_VALUE + 1))
				
				# assign fixed value to vision radius
				slime.genes.append(Config.scenario3_vision_radius)
				
			_: # SCENARIO_1
				# give random value to both genes
				slime.genes.append(randi() % (Slime.MAX_GENE_VALUE + 1))
				slime.genes.append(randi() % (Slime.MAX_GENE_VALUE + 1))
		
		# add slime to list
		slimes.append(slime)


func breed_slimes():
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
		slimes.append(breed(parent1, parent2))
		num_slimes += 1

	# remove any slimes that did not breed from the list
	for slime in slimes_copy:
		slimes.erase(slime)


func select_parent_slime(slimes : Array) -> Slime:
	# calc the total
	var total := 0.0
	for slime in slimes:
		if Config.scenario == Config.SCENARIO_3:
			total += slime.time_in_iteration
		else:
			total += slime.food_collected
	
	# if the total is 0, then choose a slime at random
	if total == 0.0:
		return slimes[randi() % slimes.size()]
	
	# generate the random value
	var r := randf() * total
	
	# select the slime with slimes who contributed more to the total being more likely to be chosen
	var sum := 0
	for slime in slimes:
		if Config.scenario == Config.SCENARIO_3:
			sum += slime.time_in_iteration
		else:
			sum += slime.food_collected
			
		if sum >= r:
			return slime
	
	# this should in theory never be reached, but return the last slime just to be safe
	return slimes.back()

	
func breed(slime1 : Slime, slime2: Slime) -> Slime:
	var new_slime : Slime = load("res://Scenes/Actors/Slime.tscn").instance()
	
	match (Config.scenario):
		Config.SCENARIO_2:
			# apply crossover to speed gene
			var gene := cross_over_genes(slime1.genes[Slime.SPEED_GENE_INDEX], slime2.genes[Slime.VISION_RADIUS_GENE_INDEX])
			new_slime.genes.append(gene)
			
			# calc vision radius
			new_slime.genes.append(Slime.MAX_GENE_VALUE - gene)
			
		Config.SCENARIO_3:
			# apply crossover to speed gene
			var gene := cross_over_genes(slime1.genes[Slime.SPEED_GENE_INDEX], slime2.genes[Slime.VISION_RADIUS_GENE_INDEX])
			new_slime.genes.append(gene)
			
			# set vision radius to fixed value
			new_slime.genes.append(Config.scenario3_vision_radius)
			
		_: # SCENARIO_1
			# apply crossover to each gene
			for i in range(slime1.genes.size()):
				var gene := cross_over_genes(slime1.genes[i], slime2.genes[i])
				new_slime.genes.append(gene)
		
	return new_slime


func cross_over_genes(gene1 : int, gene2 : int) -> int:
	var cross_str := randi()
	var new_gene : int = (gene1 & cross_str) + (gene2 & (~cross_str))
	
	# apply mutation
	for j in range(8):
		if randf() <= Config.mutation_probability:
			new_gene ^= (1 << j)
			
	return new_gene
