extends Node2D

onready var Sprite := $Sprite
onready var Particles := $Particles2D
onready var VisionCircle := $VisionCircle
onready var VisionCircleCollision := $VisionCircle/CollisionShape2D
onready var AnimationPlayer := $AnimationPlayer

export var min_speed : float
export var max_speed : float
export var min_vision_radius : float
export var max_vision_radius : float
export var wander_force : float
export var displacement_offset : float
export var angle_change : float 

export var speed_gene : int
export var vision_radius_gene : int

var init_face_dir : Vector2
var velocity : Vector2
var wander_angle := 0.0


func _ready():
	#seed the generator
	randomize()
	
	velocity = init_face_dir
	VisionCircleCollision.shape.radius = convert_gene(min_vision_radius, max_vision_radius, vision_radius_gene)
	
	set_colours()
	

func _physics_process(delta):
	var speed := convert_gene(min_speed, max_speed, speed_gene)
	
	if not pathfind_to_food(speed, delta):
		wander(speed, delta)
		
	update_walk_animation()


func convert_gene(min_value, max_value, gene_value) -> float:
	return (max_value - min_value) * (gene_value / 255.0) + min_value


func set_colours():
	var body_colour := Color.from_hsv(speed_gene/360.0, 0.74, 0.74)
	var highlight_colour := Color.from_hsv(speed_gene/360.0, 0.65, 0.89)
	
	
	Sprite.material.set_shader_param("body_color", body_colour)
	Sprite.material.set_shader_param("highlight_color", highlight_colour)
	Particles.process_material.color = body_colour


func pathfind_to_food(speed, delta) -> bool:
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
	

func wander(speed, delta):
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
		

func update_walk_animation():
	if velocity.x < 0 and velocity.y < 0:
		AnimationPlayer.play("walk_up_left")
	elif velocity.x < 0 and velocity.y > 0:
		AnimationPlayer.play("walk_down_left")
	elif velocity.x > 0 and velocity.y < 0:
		AnimationPlayer.play("walk_up_right")
	elif velocity.x > 0 and velocity.y > 0:
		AnimationPlayer.play("walk_down_right")

func collect_food():
	print("Food collected")
