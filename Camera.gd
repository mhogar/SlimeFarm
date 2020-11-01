extends Camera2D

const zoom_amount := Vector2(0.1, 0.1)
const min_zoom := Vector2(0.5, 0.5)
const max_zoom := Vector2(2.0, 2.0)

var pan_start : Vector2


func _ready():
	position.x = Config.get_env_width() / 2.0
	position.y = Config.get_env_height() / 2.0


func _process(_delta):
	handle_zoom()
	handle_pan()
			
	
func handle_zoom():
	if Input.is_action_just_released("camera_zoom_in"):
		zoom -= zoom_amount
		if zoom < min_zoom:
			zoom = min_zoom
	elif Input.is_action_just_released("camera_zoom_out"):
		zoom += zoom_amount
		if zoom > max_zoom:
			zoom = max_zoom
			

func handle_pan():
	if Input.is_action_just_pressed("camera_pan"):
		pan_start = get_viewport().get_mouse_position()
	
	if Input.is_action_pressed("camera_pan"):
		var mouse_pos := get_viewport().get_mouse_position()
		position += pan_start - mouse_pos
		pan_start = mouse_pos
		
		if position.x < 0:
			position.x = 0
		elif position.x > Config.get_env_width():
			position.x = Config.get_env_width()
			
		if position.y < 0:
			position.y = 0
		elif position.y > Config.get_env_height():
			position.y = Config.get_env_height()
		
