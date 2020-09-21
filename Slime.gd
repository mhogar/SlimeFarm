extends Node2D

export var speed : float
export var init_face_dir : Vector2

export var wander_force : float
export var displacement_offset : float
export var angle_change : float

var velocity : Vector2
var wander_angle := 0.0


func _ready():
	#seed the generator
	randomize()
	
	velocity = init_face_dir


func _physics_process(delta):
	velocity = calc_wander().clamped(speed * delta)
	position += velocity
	
	wrap_screen()


func calc_wander() -> Vector2:	
	# calc center point and displacement vector
	var displacement_center := velocity.normalized() * displacement_offset
	var displacement := Vector2(0, 1) * wander_force
	
	# update the wander angle 
	wander_angle += (randf() - 0.5) * angle_change
	
	# add the rotated displacement vector to the center point
	return displacement_center + displacement.rotated(deg2rad(wander_angle))
	

func wrap_screen():
	var env_width := 800
	var env_height := 500
	
	if position.x < 0:
		position.x = env_width
	elif position.x > env_width:
		position.x = 0
		
	if position.y < 0:
		position.y = env_height
	elif position.y > env_height:
		position.y = 0
