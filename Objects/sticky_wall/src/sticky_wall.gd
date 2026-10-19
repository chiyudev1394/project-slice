@tool
extends Area2D
class_name Wall

@export var width_scale : float = 1.0
@export var height_scale : float = 1.0

@export var width_base : float = 16.0
@export var height_base : float = 16.0

@export var push_normal : Vector2 = Vector2.ZERO

@onready var nine_patch : NinePatchRect = $NinePatchRect
@onready var collision_shape : CollisionShape2D = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Engine.is_editor_hint():
		collision_shape.shape.size = Vector2(width_base, height_base)

func _move_objects_out() -> void: 
	var overlap_obj : Array[Area2D] = self.get_overlapping_areas()
	
	for obj in overlap_obj:
		print(self.global_rotation)
		obj.global_position += push_normal.rotated(self.global_rotation)
		
	#overlap_obj = self.get_overlapping_areas()
	
	for obj in overlap_obj:
		var overlap_obj_pos = self.to_local(obj.global_position)
		var overlap_obj_angle = overlap_obj_pos.angle()
		print(obj, overlap_obj_angle)
		

func _physics_process(delta: float) -> void:
	self._move_objects_out()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# setup nine patch rect
	nine_patch.size = Vector2(width_base, height_base) * Vector2(width_scale, height_scale)
	nine_patch.position = -0.5 * nine_patch.size
	
	# setup collision shape
	collision_shape.scale = Vector2(width_scale, height_scale)


func sliced(slicer: Node2D, slice_pos : Vector2, slice_normal : Vector2) -> bool:
	print("Sliced at relative vector: ", slice_pos - global_position)
	slicer.global_position = slice_pos
	slicer.global_position += slice_normal * slicer.get_size() / 2
	slicer.sprite.global_rotation = slice_normal.angle() + PI / 2
	slicer.collision_shape.global_rotation = slice_normal.angle() + PI / 2
	slicer.reparent(self)
	return false
