extends StaticBody2D
class_name InteractableObject

# id de la instancia
@export var id: String = ""

# funcion para detectar el click izquierdo y que avisa al padre
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			MouseManager.exited(id)
			get_parent()._on_clicked_object("objetos_clicados", id)

# detecta si el cursor entra o sale y avisa al MouseManager
func _on_mouse_entered() -> void:
	MouseManager.entered(id)

func _on_mouse_exited() -> void:
	MouseManager.exited(id)
