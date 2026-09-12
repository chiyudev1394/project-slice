@tool
extends Area2D
class_name Wall

@export var width_scale : float = 1.0
@export var height_scale : float = 1.0

@export var width_base : float = 16.0
@export var height_base : float = 16.0

@onready var nine_patch : NinePatchRect = $NinePatchRect
@onready var collision_shape : CollisionShape2D = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Engine.is_editor_hint():
		collision_shape.shape.size = Vector2(width_base, height_base)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if Engine.is_editor_hint():
	# setup nine patch rect
	nine_patch.size = Vector2(width_base, height_base) * Vector2(width_scale, height_scale)
	nine_patch.position = -0.5 * nine_patch.size
	
	# setup collision shape
	collision_shape.scale = Vector2(width_scale, height_scale)


func sliced(slicer: Node2D, slice_pos : Vector2, slice_normal : Vector2) -> bool:
	print("Sliced at relative vector: ", slice_pos - global_position)
	slicer.position = slice_pos
	slicer.position += slice_normal * slicer.get_size() / 2
	slicer.sprite.rotation = slice_normal.angle() + PI / 2
	slicer.collision_shape.rotation = slice_normal.angle() + PI / 2
	return false
