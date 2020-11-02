extends Camera2D

export var zoom_step := Vector2(0.1, 0.1)
export var min_zoom := Vector2(0.5, 0.5)
export var max_zoom := Vector2(2.0, 2.0)

var env_width : int
var env_height : int

var pan_start : Vector2


func _process(_delta):
	handle_zoom()
	handle_pan()
	

func initialize(env_width : int, env_height : int):
	self.env_width = env_width
	self.env_height = env_height
	
	position.x = env_width / 2.0
	position.y = env_height / 2.0
			
	
func handle_zoom():
	if Input.is_action_just_released("camera_zoom_in"):
		zoom -= zoom_step
		if zoom < min_zoom:
			zoom = min_zoom
	elif Input.is_action_just_released("camera_zoom_out"):
		zoom += zoom_step
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
		elif position.x > env_width:
			position.x = env_width
			
		if position.y < 0:
			position.y = 0
		elif position.y > env_height:
			position.y = env_height
		
