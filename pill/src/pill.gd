extends Area2D

@export var score_points : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func sliced(slicer: Node2D, slice_pos : Vector2, slice_normal : Vector2) -> bool:
	print("Pill is sliced at relative vector: ", slice_pos - global_position)
	slicer.cur_life_time = min(slicer.cur_life_time + score_points, slicer.max_life_time)
	print(slicer.cur_life_time) 
	self.call_deferred("queue_free")
	return false
