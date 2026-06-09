extends Node2D
var cursor = preload("res://arte/cursores/cursor.png")
@onready var selector_resolucion = $resolucion
@onready var selector_modo = $modo_pantalla

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
	
	# Cambiado a tus variables reales: modo_pantalla
	selector_modo.selected = Controlador.modo_pantalla
		
	if not selector_modo.item_selected.is_connected(_on_modo_seleccionado):
		selector_modo.item_selected.connect(_on_modo_seleccionado)

func _on_modo_seleccionado(index: int) -> void:
	Controlador.cambiar_modo_pantalla(index)
	selector_resolucion.disabled = (index == 1)

func _preparar_selector_resolucion() -> void:
	selector_resolucion.clear()
	selector_resolucion.add_item("1920 x 1080 (Nativa)")
	selector_resolucion.add_item("1600 x 900")
	selector_resolucion.add_item("1280 x 720")
	selector_resolucion.add_item("1024 x 576")
	
	var popup_res = selector_resolucion.get_popup()
	popup_res.add_theme_font_size_override("font_size", 32)
	
	# Cambiado a tus variables reales: resolucion_pantalla y modo_pantalla
	selector_resolucion.selected = Controlador.resolucion_pantalla
	selector_resolucion.disabled = (Controlador.modo_pantalla == 1)
	
	if not selector_resolucion.item_selected.is_connected(_on_resolucion_seleccionada):
		selector_resolucion.item_selected.connect(_on_resolucion_seleccionada)

func _on_resolucion_seleccionada(index: int) -> void:
	Controlador.cambiar_resolucion(index)

func _on_salir_pressed() -> void:
	Controlador.cambio_escena("res://escenas/menu_inicio.tscn")
