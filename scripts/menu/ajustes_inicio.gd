extends Node2D
var cursor = preload("res://arte/cursores/cursor.png")
@onready var selector_resolucion = $resolucion
@onready var selector_modo = $modo_pantalla

const RESOLUCIONES = {
	0: Vector2i(1920, 1080),
	1: Vector2i(1600, 900),
	2: Vector2i(1280, 720),
	3: Vector2i(1024, 576)
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Controlador.modo = "investigacion"
	Input.set_custom_mouse_cursor(cursor, Input.CURSOR_ARROW)
	_preparar_selector_modo()
	_preparar_selector_resolucion()

func _preparar_selector_modo() -> void:
	selector_modo.clear()
	selector_modo.add_item("Ventana", 0)
	selector_modo.add_item("Pantalla Completa", 1)
	
	var popup_modo = selector_modo.get_popup()
	popup_modo.add_theme_font_size_override("font_size", 32)
	
	# Detectar cómo inicia el juego para poner la opción correcta
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN or DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		selector_modo.selected = 1
	else:
		selector_modo.selected = 0
		
	if not selector_modo.item_selected.is_connected(_on_modo_seleccionado):
		selector_modo.item_selected.connect(_on_modo_seleccionado)

func _on_modo_seleccionado(index: int) -> void:
	if index == 0: # Modo Ventana
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		# Al pasar a ventana, permitimos cambiar la resolución
		selector_resolucion.disabled = false
		# Forzamos a que aplique la resolución que esté marcada en el menú
		_on_resolucion_seleccionada(selector_resolucion.selected)
	elif index == 1: # Pantalla Completa
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		# En pantalla completa deshabilitamos el selector para evitar confusión
		selector_resolucion.disabled = true

func _preparar_selector_resolucion() -> void:
	selector_resolucion.clear()
	selector_resolucion.add_item("1920 x 1080 (Nativa)")
	selector_resolucion.add_item("1600 x 900")
	selector_resolucion.add_item("1280 x 720")
	selector_resolucion.add_item("1024 x 576")
	
	var popup_res = selector_resolucion.get_popup()
	popup_res.add_theme_font_size_override("font_size", 32)
	
	# Conecta la señal nativa del OptionButton a nuestra función
	selector_resolucion.item_selected.connect(_on_resolucion_seleccionada)

# Cambia el tamaño de ventana cuando el jugador elige una opción
func _on_resolucion_seleccionada(index: int) -> void:
	if RESOLUCIONES.has(index):
		var nueva_res = RESOLUCIONES[index]
		DisplayServer.window_set_size(nueva_res)
		
		# Centrar la ventana automáticamente en el monitor
		var centro = DisplayServer.screen_get_position() + (DisplayServer.screen_get_size() / 2)
		DisplayServer.window_set_position(centro - (nueva_res / 2))

func _on_salir_pressed() -> void:
	Controlador.cambio_escena("res://escenas/menu_inicio.tscn")
