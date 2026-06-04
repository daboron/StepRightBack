extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_clicked_object(type, id):
	if !SaveGame.game_data_has(type, id):
		SaveGame.game_data_add(type, id)
