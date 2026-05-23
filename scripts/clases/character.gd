extends AnimatedSprite2D
class_name Character

# id de la instancia
@export var id: String = ""
# posicion base del personaje
var base_position: Vector2

# funciones de la clase
func visibility(option: bool) -> void:
	visible = option

func play_anim(animation: String) -> void:
	play(animation)

func stop_anim() -> void:
	stop()

func focus() -> void:
	scale = Vector2(1, 1)
	position = base_position
	modulate = Color(1,1,1)

func unfocus() -> void:
	scale = Vector2(0.95,0.95)
	#como el personaje se hace pequeño, se baja para que no se corte
	position = base_position + Vector2(0, 25)
	modulate = Color(0.5,0.5,0.5)

# modificamos la posicion base del personaje
func set_base_position(pos: Vector2):
	base_position = pos
	position = pos
