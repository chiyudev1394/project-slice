extends Node2D

@onready var jump_dir : Vector2 = Vector2(0, 0)

@onready var ray_detect : bool = false
@onready var ray : RayCast2D = $RayCast2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ray.enabled = false

func _physics_process(delta: float) -> void:
	var collide_objects = []
	var collide_positions = []
	
	while ray.is_colliding():
		print("SLICE!!!")
		
		var obj = ray.get_collider()
		var hit_pos = ray.get_collision_point()
		
		collide_objects.append(obj)
		collide_positions.append(hit_pos)
		#
		#print("Name: ", obj)
		#print("Position: ", hit_pos)
		
		ray.add_exception(obj)
		ray.force_raycast_update()
	
	if collide_objects:
		ray.enabled = false
	
	for i in range(len(collide_objects)):
		collide_objects[i].sliced(self, collide_positions[i])
		ray.remove_exception(collide_objects[i])


func _update_ray_target() -> void:
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
	
	ray.target_position = min(x_coef, y_coef) * jump_dir
	print(ray.target_position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# calculate hero looking direction
	var new_jump_dir : Vector2 = get_global_mouse_position() - global_position
	
	if new_jump_dir != Vector2.ZERO:
		jump_dir = new_jump_dir.normalized()
	
	# update raycast 2d target position
	_update_ray_target()
	
	# check inputs
	
	if Input.is_action_just_pressed("Slice"):
		ray.enabled = true
	
