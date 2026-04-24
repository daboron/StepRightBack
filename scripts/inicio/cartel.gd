extends StaticBody2D

signal clicked_object(id)
var id = "cartel"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("clickable")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			emit_signal("clicked_object", id)

func _on_mouse_entered() -> void:
	if get_parent().clicked(id):
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	else:
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func _on_mouse_exited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
