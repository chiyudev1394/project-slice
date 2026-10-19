extends Node2D


var global_top_left_border : Vector2 = Vector2(INF, INF)
var global_bottom_right_border : Vector2 = Vector2(-INF, -INF)

# install current left bottom and right top borders of the box
func _setup_borders() -> void:
	for child in self.get_children():
		var child_glob_pos = child.global_position
		
		global_top_left_border = Vector2(min(global_top_left_border.x, child_glob_pos.x), 
											min(global_top_left_border.y, child_glob_pos.y))
		global_bottom_right_border = Vector2(max(global_bottom_right_border.x, child_glob_pos.x), 
											max(global_bottom_right_border.y, child_glob_pos.y))

func get_box_borders() -> Array:
	return [global_top_left_border, global_bottom_right_border]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self._setup_borders()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
