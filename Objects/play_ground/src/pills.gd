extends Node2D

@onready var box : Node2D = %Box
@onready var respawn_timer : Timer = Timer.new()

var global_top_left_border : Vector2 = Vector2.ZERO
var global_bottom_right_border : Vector2 = Vector2.ZERO

var active_pills : Array = []
var not_active_pills : Array = []

func _set_pills_random_position(pill : Pill) -> void:
	var random_x_pos : float = randf_range(global_top_left_border.x, 
											global_bottom_right_border.x)
	var random_y_pos : float = randf_range(global_top_left_border.y,
											global_bottom_right_border.y)
	pill.global_position = Vector2(random_x_pos, random_y_pos)

func _pill_deactivation(pill : Pill) -> void:
	pill.deactivate()
	active_pills.erase(pill)
	not_active_pills.append(pill)
	
	if len(not_active_pills) == 0:
		respawn_timer.start()

func _pill_activation(pill : Pill) -> void:
	pill.activate()
	not_active_pills.erase(pill)
	active_pills.append(pill)
	self._set_pills_random_position(pill)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# setup borders for spawning objects
	var box_borders : Array = box.get_box_borders()
	global_top_left_border = box_borders[0]
	global_bottom_right_border = box_borders[1]
	
	# put all pills into not_active_pills array
	for pill in self.get_children():
		active_pills.append(pill)
		self._set_pills_random_position(pill)
		
		if pill.has_signal("pill_sliced"):
			pill.pill_sliced.connect(self._pill_deactivation.bind(pill))
		#pill.deactivate()
	
	# setup pill respawn timer
	respawn_timer.wait_time = 2.0
	respawn_timer.one_shot = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# respawn not active pills
	if !not_active_pills.is_empty():
		print(respawn_timer.wait_time)
		if respawn_timer.is_stopped():
			self._pill_activation(not_active_pills[0])
			
			if !not_active_pills.is_empty():
				respawn_timer.start()
	else:
		respawn_timer.stop()
