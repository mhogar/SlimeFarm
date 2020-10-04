extends Node2D

class_name Food


func _ready():
	pass


func _on_Food_body_entered(body):
	body.collect_food()
	queue_free()
