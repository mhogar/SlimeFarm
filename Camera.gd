extends Camera2D

const zoom_amount := Vector2(0.1, 0.1)
const min_zoom := Vector2(0.5, 0.5)
const max_zoom := Vector2(2.0, 2.0)


func _ready():
	pass


func _process(delta):
	if Input.is_action_just_released("camera_zoom_in"):
		zoom -= zoom_amount
		if zoom < min_zoom:
			zoom = min_zoom
	elif Input.is_action_just_released("camera_zoom_out"):
		zoom += zoom_amount
		if zoom > max_zoom:
			zoom = max_zoom
