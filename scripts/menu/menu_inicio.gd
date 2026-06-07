extends Node2D

@onready var boton_nueva_partida = $nueva
@onready var boton_continuar = $continuar

var cursor = preload("res://arte/cursores/cursor.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Controlador.modo_actual = "investigacion"
	Input.set_custom_mouse_cursor(cursor, Input.CURSOR_ARROW)
	if SaveGame.existe_partida():
		SaveGame.load_game()
		boton_continuar.disabled = false
		boton_continuar.release_focus()
		boton_continuar.mouse_filter = Control.MOUSE_FILTER_STOP
	else:
		boton_continuar.disabled = true


func _on_continuar_pressed() -> void:
	Controlador.cargar_partida_guardada()


func _on_nueva_pressed() -> void:
	#empezamos a precargar la escena siguiente
	ResourceLoader.load_threaded_request("res://escenas/inicio.tscn")
	SaveGame.new_game()
	Controlador.cambio_escena("res://escenas/inicio.tscn")
