extends Area2D
class_name Pill

signal pill_sliced

@onready var collision_shape : CollisionShape2D = $CollisionShape2D

@export var score_points : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# method that makes pills invisiable and not solid
func deactivate() -> void:
	self.visible = false
	self.monitorable = false
	self.monitoring = false
	collision_shape.disabled = true

# method that makes pills visiable and not solid
func activate() -> void:
	self.visible = true
	self.monitorable = true
	self.monitoring = true
	collision_shape.disabled = false

func sliced(slicer: Node2D, slice_pos : Vector2, slice_normal : Vector2) -> bool:
	#print("Pill is sliced at relative vector: ", slice_pos - global_position)
	slicer.cur_life_time = min(slicer.cur_life_time + score_points, slicer.max_life_time)
	#print(slicer.cur_life_time) 
	self.deactivate()
	pill_sliced.emit()
	#self.call_deferred("queue_free")
	return false
