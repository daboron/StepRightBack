# Por revisar
extends CanvasLayer
@onready var protagonista = $protagonista

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	protagonista.visibility(true)
	protagonista.play_anim("default")

func abrir():
	visible = true

func cerrar():
	visible = false
