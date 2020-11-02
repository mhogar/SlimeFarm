extends Node2D

export var time_scale := 4.0

onready var Iteration := $Iteration
onready var Population := $Population

var iteration : int
var csv_file : File


func _ready():
	# seed the generator
	randomize()
	
	init_simulation()
	
	iteration = 1
	Population.initiaize()
	Iteration.start_new(Population.slimes)


func _exit_tree():
	csv_file.close()


func init_simulation():
	Engine.set_time_scale(time_scale)
	create_csv()


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
	Population.breed_slimes()
	Iteration.start_new(Population.slimes)
