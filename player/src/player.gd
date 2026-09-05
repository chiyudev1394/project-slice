extends Node2D

@onready var jump_dir : Vector2 = Vector2(0, 0)

@onready var ray_detect : bool = false
@onready var ray_cast : RayCast2D = $RayCast2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ray_cast.enabled = false

func _physics_process(delta: float) -> void:
	if ray_cast.is_colliding():
		print("SLICE!!!")
		
		ray_cast.enabled = false


func _update_ray_cast_target() -> void:
	var x_coef : float = INF
	var y_coef : float = INF
	var viewport_size : Vector2 = get_viewport().get_visible_rect().size
	
	if jump_dir.x < 0.0:
		x_coef = - position.x / jump_dir.x
	elif jump_dir.x > 0.0:
		x_coef = (viewport_size.x - position.x) / jump_dir.x
	
	if jump_dir.y < 0.0:
		y_coef = - position.y / jump_dir.y
	elif jump_dir.y > 0.0:
		y_coef = (viewport_size.y - position.y) / jump_dir.y
	
	ray_cast.target_position = min(x_coef, y_coef) * jump_dir


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# calculate hero looking direction
	var new_jump_dir : Vector2 = get_global_mouse_position() - position
	
	if new_jump_dir != Vector2.ZERO:
		jump_dir = new_jump_dir.normalized()
	
	# update raycast 2d target position
	_update_ray_cast_target()
	
	# check inputs
	
	if Input.is_action_just_pressed("Slice"):
		ray_cast.enabled = true
	
