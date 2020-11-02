extends Node2D

const max_time_scale := 8.0
const min_time_scale := 1.0

export var num_tiles_x : int
export var num_tiles_y : int
export var pop_size : int
export var num_food : int
export var mutation_prob : float

onready var Environment := $Environment
onready var Camera := $Camera
onready var Iteration := $Iteration
onready var Population := $Population

var iteration : int
var csv_file : File


func _ready():
	# seed the generator
	randomize()
	
	init_simulation()
	
	iteration = 1
	Iteration.start_new()


func _exit_tree():
	csv_file.close()


func _process(_delta):
	if Input.is_action_just_pressed("speed_up") && Engine.time_scale < max_time_scale:
		Engine.time_scale *= 2.0
	elif Input.is_action_just_pressed("slow_down") && Engine.time_scale > min_time_scale:
		Engine.time_scale /= 2.0


func init_simulation():
	Engine.set_time_scale(min_time_scale)
	create_csv()
	
	var env_width : int = num_tiles_x * Environment.cell_size.x
	var env_height : int = num_tiles_y * Environment.cell_size.y
	
	Environment.initialize(num_tiles_x, num_tiles_y)
	Camera.initialize(env_width, env_height)
	Population.initiaize(pop_size)
	Iteration.initialize(env_width, env_height, Population.slimes, num_food)


func create_csv():
	csv_file = File.new()
	csv_file.open("user://data_%d.csv" % OS.get_unix_time(), File.WRITE)
	csv_file.store_line("Iteration,Time (s),Avg. Speed,Avg. Vision Radius")
	
	
func export_stats():
	var data := PoolStringArray([iteration])
	#data.append(String(iteration))
	data.append_array(PoolStringArray(Iteration.stats))
	
	csv_file.store_csv_line(data)
	

func _on_Iteration_finished():
	export_stats()
	
	iteration += 1
	Population.breed_slimes(mutation_prob)
	Iteration.start_new()
