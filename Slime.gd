extends Node2D

onready var VisionCircle := $VisionCircle
onready var VisionCircleCollision := $VisionCircle/CollisionShape2D
onready var AnimationPlayer := $AnimationPlayer

export var speed : float
export var init_face_dir : Vector2
export var wander_force : float
export var displacement_offset : float
export var angle_change : float
export var vision_radius : float

var velocity : Vector2
var wander_angle := 0.0


func _ready():
	#seed the generator
	randomize()
	
	velocity = init_face_dir
	VisionCircleCollision.shape.radius = vision_radius
	
	AnimationPlayer.play("walk")


func _physics_process(delta):
	if not pathfind_to_food(delta):
		wander(delta)


func pathfind_to_food(delta) -> bool:
	var dir := find_closest_food()
	
	# check for zero vector
	if dir.length_squared() < 1:
		return false
	
	# update velocity and position
	velocity = dir
	position += velocity * speed * delta
	
	return true


func find_closest_food() -> Vector2:
	var visible_food = VisionCircle.get_overlapping_areas()
	
	var target_pos := position
	var smallest_dist := -1.0
	
	for food in visible_food:
		var dist := position.distance_squared_to(food.position)
		
		if smallest_dist < 0 or dist < smallest_dist:
			target_pos = food.position
			smallest_dist = dist
	
	# returns zero vector if no food is visible
	return position.direction_to(target_pos)
	

func wander(delta):
	velocity = calc_wander().clamped(speed * delta)
	position += velocity
	
	wrap_screen()


func calc_wander() -> Vector2:	
	# calc center point and displacement vector
	var displacement_center := velocity.normalized() * displacement_offset
	var displacement := Vector2(0, -1) * wander_force
	
	# update the wander angle 
	wander_angle += (randf() - 0.5) * angle_change
	
	# add the rotated displacement vector to the center point
	return displacement_center + displacement.rotated(deg2rad(wander_angle))
	

func wrap_screen():
	var env := get_parent().get_parent()
	
	if position.x < 0:
		position.x = env.env_width
	elif position.x > env.env_width:
		position.x = 0
		
	if position.y < 0:
		position.y = env.env_height
	elif position.y > env.env_height:
		position.y = 0
		

func collect_food():
	print("Food collected")
