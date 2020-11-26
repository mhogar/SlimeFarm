extends Camera2D

export var zoom_step := Vector2(0.1, 0.1)
export var min_zoom := Vector2(0.5, 0.5)
export var max_zoom := Vector2(2.0, 2.0)

var pan_start : Vector2


func _process(_delta):
	if Input.is_action_just_pressed("camera_pan"):
		pan_start = get_viewport().get_mouse_position()
	
	if Input.is_action_pressed("camera_pan"):
		var mouse_pos := get_viewport().get_mouse_position()
		position += pan_start - mouse_pos
		pan_start = mouse_pos
		
		var env_width := Config.calc_env_width()
		if position.x < 0:
			position.x = 0
		elif position.x > env_width:
			position.x = env_width
			
		var env_height := Config.calc_env_height()
		if position.y < 0:
			position.y = 0
		elif position.y > env_height:
			position.y = env_height
		
	
func _unhandled_input(event):
	if event.is_action_released("camera_zoom_in"):
		zoom -= zoom_step
		if zoom < min_zoom:
			zoom = min_zoom
	elif event.is_action_released("camera_zoom_out"):
		zoom += zoom_step
		if zoom > max_zoom:
			zoom = max_zoom
	

func center():
	position.x = Config.calc_env_width() / 2.0
	position.y = Config.calc_env_height() / 2.0
	
