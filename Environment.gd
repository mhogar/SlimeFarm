extends Node2D

export var env_width : int
export var env_height : int
export var num_slimes : int
export var num_food : int

onready var Slimes := $Slimes
onready var Food := $Food
onready var TemplateSlime := $Slimes/TemplateSlime

var interation := 0


func _ready():
	# seed the generator
	randomize()
	
	init_simulation()
	start_iteration()


func _process(delta):
	# check iteration is over
	if Food.get_child_count() == 0:
		end_iteration()


func init_simulation():
	create_slimes()
	TemplateSlime.queue_free()


func start_iteration():
	interation += 1
	
	setup_slimes()
	create_food()
	

func end_iteration():
	# TODO: genetic algo stuff
	
	start_iteration()
	

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


func setup_slimes():
	for slime in Slimes.get_children():
		# choose random position
		slime.position.x = randf() * env_width
		slime.position.y = randf() * env_height
		
		# choose random starting face direction
		slime.init_face_dir.x = randf()
		slime.init_face_dir.y = randf()


func create_food():
	var scene = load("res://Food.tscn")
	
	for i in range(num_food):
		var food = scene.instance()
		
		# choose random position
		food.position.x = randf() * env_width
		food.position.y = randf() * env_height
		
		# add slime to list
		Food.add_child(food)
