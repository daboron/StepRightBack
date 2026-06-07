extends InteractableObject
class_name InteractableCharacter

# Guardamos la ruta o el PackedScene de la escena del cuaderno
@export var escena_cuaderno = preload("res://escenas/interaccion_personaje.tscn")

# Sobreescribimos la función de clic
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			MouseManager.exited(id)
			get_parent().on_clicked_character(self)
