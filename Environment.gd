extends Node2D

export var env_width : int
export var env_height : int
export var num_slimes : int
export var num_food : int

onready var TemplateSlime := $Simes/TemplateSlime
onready var TemplateFood := $Food/TemplateFood


func _ready():
	# seed the generator and create the slimes and food
	randomize()
	create_slimes()
	create_food()
	
	# remove templates now before the game starts
	TemplateSlime.queue_free()
	TemplateFood.queue_free()


func create_slimes():
	for i in range(num_slimes):
		var slime := TemplateSlime.duplicate()
		
		# choose random position
		slime.position.x = randf() * env_width
		slime.position.y = randf() * env_height
		
		# choose random starting face direction
		slime.init_face_dir.x = randf()
		slime.init_face_dir.y = randf()
		
		# add slime to list
		TemplateSlime.get_parent().add_child(slime)


func create_food():
	for i in range(num_food):
		var food := TemplateFood.duplicate()
		
		# choose random position
		food.position.x = randf() * env_width
		food.position.y = randf() * env_height
		
		# add slime to list
		TemplateFood.get_parent().add_child(food)
