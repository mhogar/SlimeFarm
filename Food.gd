extends Node2D


func _ready():
	pass


func _on_Food_body_entered(body):
	body.collect_food()
	queue_free()
