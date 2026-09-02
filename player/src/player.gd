extends Node2D

@onready var look_dir : Vector2 = Vector2(0, 0)

@onready var ray_cast : RayCast2D = $RayCast2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _update_ray_cast_target() -> void:
	var x_coef : float = INF
	var y_coef : float = INF
	var viewport_size : Vector2 = get_viewport().get_visible_rect().size
	
	print(viewport_size.x)
	
	if look_dir.x < 0.0:
		x_coef = - position.x / look_dir.x
	elif look_dir.x > 0.0:
		x_coef = (viewport_size.x - position.x) / look_dir.x
	
	if look_dir.y < 0.0:
		y_coef = - position.y / look_dir.y
	elif look_dir.y > 0.0:
		y_coef = (viewport_size.y - position.y) / look_dir.y
	
	ray_cast.target_position = min(x_coef, y_coef) * look_dir


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# calculate hero looking direction
	var new_look_dir : Vector2 = get_global_mouse_position() - position
	
	if new_look_dir != Vector2.ZERO:
		look_dir = new_look_dir.normalized()
	
	print(look_dir)
	
	# update raycast 2d target position
	
	_update_ray_cast_target()
	#print(ray_cast.target_position)
	
	## casting ray in looking direction
	#var space_state = get_world_2d().direct_space_state
	#var query = PhysicsRayQueryParameters2D.create(global_position, global_position + 1000 * look_dir)
	#var result = space_state.intersect_ray(query)
	#
	#if result:
		#print("Hit at point: ", result.position)
