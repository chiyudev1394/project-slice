extends Area2D
class_name Spike

@export var score_points : float = 1.5
@export var unactive_time : float = 8.0
@export var blink_time : float = 0.1

@onready var unactive_timer : Timer = $UnactiveTimer
@onready var blink_timer : Timer = $BlinkTimer
@onready var sprite : Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	blink_timer.wait_time = blink_time

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(blink_timer.is_stopped(), unactive_timer.time_left)
	if blink_timer.is_stopped() and unactive_timer.time_left > 0.0:
		sprite.visible = not sprite.visible
		blink_timer.start(blink_time)

func sliced(slicer: Node2D, slice_pos : Vector2, slice_normal : Vector2) -> bool:
	if unactive_timer.time_left > 0.0:
		return false
	print("Spike is sliced at relative vector: ", slice_pos - global_position)
	slicer.cur_life_time = max(slicer.cur_life_time - score_points, 0.0)
	print(slicer.cur_life_time) 
	unactive_timer.start(unactive_time)
	blink_timer.start(blink_time)
	#self.call_deferred("queue_free")
	return false
