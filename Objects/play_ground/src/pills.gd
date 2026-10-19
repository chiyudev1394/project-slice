extends Node2D

@onready var box : Node2D = %Box

var global_left_bottom_point : Vector2 = Vector2.ZERO
var global_right_top_point : Vector2 = Vector2.ZERO

var active_pills : Array = []
var not_active_pills : Array = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# setup borders for spawning objects
	var box_borders : Array = box.get_box_borders()
	global_left_bottom_point = box_borders[0]
	global_right_top_point = box_borders[1]
	
	# put all pills into not_active_pills array
	for pill in self.get_children():
		not_active_pills.append(pill)
		pill.deactivate()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(global_left_bottom_point)
	print(global_right_top_point)
