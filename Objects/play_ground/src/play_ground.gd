extends Node2D

@onready var ui : Control = %UI
@onready var game_objects : Node2D = %GameObjects


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Pause"):
		self.get_tree().paused = not self.get_tree().paused
