extends Node

var menu_scene = preload("res://escenas/menu.tscn")
var menu_instance
var esperando_cierre_de_menu = false
var cursor = preload("res://arte/cursores/pointer.png")
var cursor_previo: Resource = null

signal cerrar_espera_menu

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	menu_instance = menu_scene.instantiate()
	get_tree().root.call_deferred("add_child", menu_instance)
	menu_instance.visible = false

func _input(event):
	if event.is_action_pressed("menu"):
		toggle_menu()

func toggle_menu():
	var abrir = !menu_instance.visible
	
	if not abrir and esperando_cierre_de_menu:
		esperando_cierre_de_menu = false
		cerrar_espera_menu.emit()

	if not abrir:
		if Controlador.modo == "puzzle":
			Input.set_custom_mouse_cursor(load("res://arte/cursores/pointer.png"), Input.CURSOR_ARROW)
		else:
			Input.set_custom_mouse_cursor(load("res://arte/cursores/cursor.png"), Input.CURSOR_ARROW)
		menu_instance.reset_tab_state()
	else:
		var escena_actual = get_tree().current_scene
		if escena_actual and "puzzle" in escena_actual.name.to_lower():
			cursor_previo = load("res://arte/cursores/pointer.png")
		else:
			cursor_previo = load("res://arte/cursores/cursor.png")
		Input.set_custom_mouse_cursor(cursor, Input.CURSOR_ARROW)
	
	menu_instance.visible = abrir
	get_tree().paused = abrir

	if abrir and menu_instance.current_tab == null:
		menu_instance._init_first_tab()

	for node in get_tree().root.get_children():
		gestionar_visibilidad_dialogos(node, abrir)

func gestionar_visibilidad_dialogos(node, menu_abierto):
	if node is CanvasLayer and node != menu_instance:
		var nombre = node.name.to_lower()
		if "dialog" in nombre or "balloon" in nombre:
			node.visible = not menu_abierto

	for child in node.get_children():
		gestionar_visibilidad_dialogos(child, menu_abierto)

func activar_espera_menu() -> void:
	esperando_cierre_de_menu = true
