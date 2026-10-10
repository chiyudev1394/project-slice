extends Area2D
class_name Player

@export var max_life_time : float = 10.0
@onready var cur_life_time : float = max_life_time

@onready var jump_dir : Vector2 = Vector2(0, 0)

@onready var ray_cast_detect : bool = false
@onready var ray_cast : RayCast2D = $RayCast2D

@onready var sprite : Sprite2D = $Sprite2D
@onready var collision_shape : CollisionShape2D = $CollisionShape2D

@onready var laser : Line2D = $Laser


#@onready var shape_cast : ShapeCast2D = $ShapeCast2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ray_cast.enabled = true


func _physics_process(delta: float) -> void:
	var perform_slice : bool = false
	
	if Input.is_action_just_pressed("Slice"):
		perform_slice = true
	
	while ray_cast.is_colliding():
		var obj = ray_cast.get_collider()
		var hit_pos_ray : Vector2 = ray_cast.get_collision_point()
		var hit_normal : Vector2 = ray_cast.get_collision_normal()
		
		if perform_slice:
			obj.sliced(self, hit_pos_ray, hit_normal)
		
		if obj is Wall:
			laser.set_point_position(1, self.to_local(hit_pos_ray))
			break
		
		ray_cast.add_exception(obj)
		ray_cast.force_raycast_update()
	
	ray_cast.clear_exceptions()

func _update_ray_cast_target() -> void:
	var x_coef : float = INF
	var y_coef : float = INF
	var viewport_size : Vector2 = get_viewport().get_visible_rect().size
	var global_jump_dir : Vector2 = (get_global_mouse_position() - self.global_position).normalized()
	
	if global_jump_dir.x < 0.0:
		x_coef = -self.global_position.x / global_jump_dir.x
	elif global_jump_dir.x > 0.0:
		x_coef = (viewport_size.x - self.global_position.x) / global_jump_dir.x
	
	if global_jump_dir.y < 0.0:
		y_coef = -self.global_position.y / global_jump_dir.y
	elif global_jump_dir.y > 0.0:
		y_coef = (viewport_size.y - self.global_position.y) / global_jump_dir.y
	
	ray_cast.target_position = min(x_coef, y_coef) * jump_dir
	#ray_cast.target_position = 500 * jump_dir
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
	var new_jump_dir : Vector2 = to_local(get_global_mouse_position())
	#print(new_jump_dir)
	#print(ray_cast.position)
	
	if new_jump_dir != Vector2.ZERO:
		jump_dir = new_jump_dir.normalized()
	
	# update ray_castcast 2d target position
	_update_ray_cast_target()
	
	# check inputs
	#if Input.is_action_just_pressed("Slice"):
		#ray_cast.enabled = true
		#shape_cast.enabled = true

func get_size() -> Vector2:
	return sprite.texture.get_size() * sprite.scale
