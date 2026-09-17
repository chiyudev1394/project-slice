extends Area2D
class_name Player

@export var max_life_time : float = 10.0
@onready var cur_life_time : float = max_life_time

@onready var jump_dir : Vector2 = Vector2(0, 0)

@onready var ray_cast_detect : bool = false
@onready var ray_cast : RayCast2D = $RayCast2D

@onready var sprite : Sprite2D = $Sprite2D
@onready var collision_shape : CollisionShape2D = $CollisionShape2D


#@onready var shape_cast : ShapeCast2D = $ShapeCast2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ray_cast.enabled = false
	#shape_cast.enabled = false

func _physics_process(delta: float) -> void:
	var collide_objects = []
	var collide_positions = []
	var collide_normal = []
	
	while ray_cast.is_colliding():
		print("SLICE!!!")
		
		var obj = ray_cast.get_collider()
		var hit_pos_ray : Vector2 = ray_cast.get_collision_point()
		var hit_normal : Vector2 = ray_cast.get_collision_normal()
		#var hit_pos_shape : Vector2 = shape_cast.get_collision_point(0)
		
		#print(shape_cast.collision_result)
		
		collide_objects.append(obj)
		collide_positions.append(hit_pos_ray)
		collide_normal.append(hit_normal)
		#collide_positions_shape.append(hit_pos_shape)
		
		#print(hit_pos_ray)
		#print(hit_pos_shape)
		
		ray_cast.add_exception(obj)
		ray_cast.force_raycast_update()
		#shape_cast.force_shapecast_update()
	
	if collide_objects:
		ray_cast.enabled = false
		#shape_cast.enabled = false
	
	#print(len(collide_objects))
	
	var first_wall_touched : bool = false
	
	for i in range(len(collide_objects)):
		if not first_wall_touched:
			collide_objects[i].sliced(self, collide_positions[i], collide_normal[i])
		
		if collide_objects[i] is Wall:
			first_wall_touched = true
		ray_cast.remove_exception(collide_objects[i])


func _update_ray_cast_target() -> void:
	var x_coef : float = INF
	var y_coef : float = INF
	var viewport_size : Vector2 = get_viewport().get_visible_rect().size
	
	if jump_dir.x < 0.0:
		x_coef = - global_position.x / jump_dir.x
	elif jump_dir.x > 0.0:
		x_coef = (viewport_size.x - global_position.x) / jump_dir.x
	
	if jump_dir.y < 0.0:
		y_coef = - global_position.y / jump_dir.y
	elif jump_dir.y > 0.0:
		y_coef = (viewport_size.y - global_position.y) / jump_dir.y
	
	ray_cast.target_position = min(x_coef, y_coef) * jump_dir
	#shape_cast.target_position = ray_cast.target_position
	#print(ray_cast.target_position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# check if alive
	if cur_life_time <= 0:
		print("You are dead")
		self.queue_free()
	
	cur_life_time -= delta
	
	# calculate hero looking direction
	var new_jump_dir : Vector2 = get_global_mouse_position() - global_position
	
	if new_jump_dir != Vector2.ZERO:
		jump_dir = new_jump_dir.normalized()
	
	# update ray_castcast 2d target position
	_update_ray_cast_target()
	
	# check inputs
	if Input.is_action_just_pressed("Slice"):
		ray_cast.enabled = true
		#shape_cast.enabled = true

func get_size() -> Vector2:
	return sprite.texture.get_size() * sprite.scale
