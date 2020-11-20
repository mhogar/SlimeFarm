extends Node2D

class_name Slime


onready var Sprite := $Sprite
onready var Particles := $Particles2D
onready var VisionCircle := $VisionCircle
onready var VisionCircleCollision := $VisionCircle/CollisionShape2D
onready var EnergyIndicator := $EnergyIndicator
onready var AnimationPlayer := $AnimationPlayer


export var min_speed : float
export var max_speed : float
export var min_vision_radius : float
export var max_vision_radius : float
export var wander_force : float
export var displacement_offset : float
export var angle_change : float
export var energy_consumption_speed : float

var genes : Array
const MAX_GENE_VALUE : int = 255
enum {SPEED_GENE_INDEX, VISION_RADIUS_GENE_INDEX}

var body_colour : Color
var highlight_colour : Color
var vision_circle_colour : Color

var init_face_dir : Vector2
var velocity : Vector2
var wander_angle := 0.0

var food_collected : int


func _ready():
	reset()
	init_energy_indicator()
	velocity = init_face_dir
	VisionCircleCollision.shape.radius = convert_gene(min_vision_radius, max_vision_radius, VISION_RADIUS_GENE_INDEX)
	
	calc_colours()


func _physics_process(delta : float):
	var speed := convert_gene(min_speed, max_speed, SPEED_GENE_INDEX)
	
	if not pathfind_to_food(speed, delta):
		wander(speed, delta)
	
	if EnergyIndicator.value <= 0:
		get_parent().remove_child(self)
	
	update_walk_animation()


func _draw():
	# draw the vision circle
	draw_arc(Vector2(), VisionCircleCollision.shape.radius, deg2rad(0), deg2rad(360), 35, vision_circle_colour, 2)


func reset():
	food_collected = 0
	
	if Config.scenario == Config.SCENARIO_3:
		update_energy_indicator(EnergyIndicator.max_value)


func init_energy_indicator():
	if Config.scenario == Config.SCENARIO_3:
		EnergyIndicator.max_value = Config.scenario3_max_energy
		EnergyIndicator.value = EnergyIndicator.max_value
		configure_energy_step()
	else:
		EnergyIndicator.hide()


func configure_energy_step():
	var modifer := Config.scenario3_energy_consumption_modifier
	var inverse_modifier : float = 1.0 / modifer
	
	var val : int = genes[SPEED_GENE_INDEX]
	var mid_val : float = MAX_GENE_VALUE / 2.0
	
	if val < mid_val:
		EnergyIndicator.step = (val / mid_val) * inverse_modifier + inverse_modifier
	else:
		EnergyIndicator.step = (val - mid_val) / (MAX_GENE_VALUE - mid_val) * (modifer - 1) + 1


func convert_gene(min_value : int, max_value : int, gene_index : int) -> float:
	return (max_value - min_value) * (genes[gene_index] / float(MAX_GENE_VALUE)) + min_value


func calc_colours():
	var speed_gene : int = genes[SPEED_GENE_INDEX]
	var vision_radius_gene : int = genes[VISION_RADIUS_GENE_INDEX]
	
	body_colour = Color.from_hsv(speed_gene/360.0, 0.74, 0.74)
	highlight_colour = Color.from_hsv(speed_gene/360.0, 0.65, 0.89)
	vision_circle_colour = Color.from_hsv(vision_radius_gene/360.0, 0.65, 0.89)
	
	Sprite.material.set_shader_param("body_color", body_colour)
	Sprite.material.set_shader_param("highlight_color", highlight_colour)
	Particles.process_material.color = body_colour
	

func pathfind_to_food(speed : float, delta : float) -> bool:
	var dir := find_closest_food()
	
	# check for zero vector
	if dir.length_squared() < 1:
		return false
	
	# update velocity and position
	velocity = dir * speed * delta
	move(velocity, delta)
	
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
	

func wander(speed : float, delta : float):
	velocity = calc_wander().clamped(speed * delta)
	move(velocity, delta)
	
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
	var env_width = Config.calc_env_width()
	if position.x < 0:
		position.x = env_width
	elif position.x > env_width:
		position.x = 0
		
	var env_height = Config.calc_env_height()
	if position.y < 0:
		position.y = env_height
	elif position.y > env_height:
		position.y = 0


func move(velocity : Vector2, delta : float):
	position += velocity
	
	if Config.scenario == Config.SCENARIO_3:
		update_energy_indicator(EnergyIndicator.value - (EnergyIndicator.step * energy_consumption_speed * delta))


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
	food_collected += 1
	update_energy_indicator(EnergyIndicator.max_value)
	

func update_energy_indicator(value : float):
	EnergyIndicator.value = value
