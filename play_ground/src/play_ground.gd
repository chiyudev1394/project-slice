extends Node2D

@onready var player : Area2D = $Player
@onready var player_hp_bar : ProgressBar = $PlayerHealthBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_hp_bar.max_value = player.max_life_time


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player != null:
		player_hp_bar.value = player.cur_life_time
