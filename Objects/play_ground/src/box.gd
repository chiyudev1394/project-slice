extends Node2D


var global_left_bottom_border : Vector2 = Vector2(INF, -INF)
var global_right_top_border : Vector2 = Vector2(-INF, INF)

# install current left bottom and right top borders of the box
func _setup_borders() -> void:
	for child in self.get_children():
		var child_glob_pos = child.global_position
		
		global_left_bottom_border = Vector2(min(global_left_bottom_border.x, child_glob_pos.x), 
											max(global_left_bottom_border.y, child_glob_pos.y))
		global_right_top_border = Vector2(max(global_right_top_border.x, child_glob_pos.x), 
											min(global_right_top_border.y, child_glob_pos.y))

func get_box_borders() -> Array:
	return [global_left_bottom_border, global_right_top_border]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self._setup_borders()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
