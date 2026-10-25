extends Node2D

@onready var box : Node2D = %Box
@onready var respawn_timer : Timer = $PillRespawnTimer

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
	if respawn_timer.is_stopped():
		respawn_timer.start()
	
	pill.deactivate()
	active_pills.erase(pill)
	not_active_pills.append(pill)

func _pill_activation() -> void:
	var pill : Pill = self.not_active_pills[0]
	pill.activate()
	not_active_pills.erase(pill)
	active_pills.append(pill)
	self._set_pills_random_position(pill)
	
	if len(not_active_pills) == 0:
		respawn_timer.stop()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# setup borders for spawning objects
	var box_borders : Array = box.get_box_borders()
	global_top_left_border = box_borders[0]
	global_bottom_right_border = box_borders[1]
	
	# put all pills into not_active_pills array
	for item in self.get_children():
		if item is not Pill:
			continue
		
		active_pills.append(item)
		self._set_pills_random_position(item)
		
		if item.has_signal("pill_sliced"):
			item.pill_sliced.connect(self._pill_deactivation.bind(item))
		#pill.deactivate()
	
	# setup pill respawn timer
	respawn_timer.timeout.connect(self._pill_activation)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# respawn not active pills
	print(respawn_timer.time_left)
