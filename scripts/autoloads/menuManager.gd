extends Node

var menu_scene = preload("res://escenas/menu.tscn")
var menu_instance
var esperando_cierre_de_menu = false
var cursor = preload("res://arte/cursores/pointer.png")
var cursor_previo: Resource = null

signal cerrar_espera_menu

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	var capa_menu = CanvasLayer.new()
	capa_menu.layer = 1000
	capa_menu.name = "CapaMenuGlobal"
	get_tree().root.call_deferred("add_child", capa_menu)
	menu_instance = menu_scene.instantiate()
	capa_menu.add_child(menu_instance)
	menu_instance.visible = false

func _input(event):
	if event.is_action_pressed("menu") && Controlador.dentro_juego:
		toggle_menu()

func toggle_menu():
	var abrir = !menu_instance.visible
	print("\n--- [MENU] INTERRUPTOR PULSADO. ¿Abrir?: ", abrir, " | Modo actual: ", Controlador.modo, " ---")
	
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
		
	# Rastreamos qué pasa con la detective
	print("[DEBUG] ¿CharacterManager tiene detective?: ", CharacterManager.personajes.has("detective"))
	if CharacterManager.personajes.has("detective"):
		var nodo_detective = CharacterManager.personajes["detective"]
		if is_instance_valid(nodo_detective):
			print("[DEBUG] Detective encontrada en escena. Visibilidad antes de cambiar: ", nodo_detective.visible)
			# Quitamos temporalmente el filtro de modo puzzle para probar si la apaga aquí
			if abrir:
				nodo_detective.set_meta("visibilidad_previa", nodo_detective.visible)
				nodo_detective.visible = false
			else:
				if nodo_detective.has_meta("visibilidad_previa"):
					nodo_detective.visible = nodo_detective.get_meta("visibilidad_previa")
				else:
					# Por si acaso no se hubiera guardado, por defecto la dejamos oculta
					nodo_detective.visible = false
			print("[DEBUG] Visibilidad después de cambiar: ", nodo_detective.visible)
	
	print("[DEBUG] Iniciando escaneo de nodos en la raíz de la ventana...")
	for node in get_tree().root.get_children():
		gestionar_visibilidad_dialogos(node, abrir)

func gestionar_visibilidad_dialogos(node, menu_abierto):
	if node == null:
		return

	# Chivato para ver pasar TODOS los CanvasLayer del juego
	if node is CanvasLayer:
		print("  -> Encontrado CanvasLayer: '", node.name, "' | Visibilidad actual: ", node.visible)
		
		# Corregimos la estructura: Evaluamos de forma independiente a la CapaMenuGlobal
		if node.name == "CapaMenuGlobal":
			print("     [INFO] Es la capa del menú. No la ocultamos, pero escaneamos sus hijos.")
		elif node != menu_instance:
			var nombre = node.name.to_lower()
			if "dialog" in nombre or "balloon" in nombre or "line" in nombre:
				print("     [¡ALERTA!] Detectada capa de diálogo: '", node.name, "'. Cambiando visible a: ", not menu_abierto)
				if menu_abierto:
					# 1. Al ABRIR, guardamos si el diálogo se estaba mostrando realmente
					node.set_meta("visibilidad_previa_dialogo", node.visible)
					node.visible = false
				else:
					# 2. Al CERRAR, solo lo encendemos si estaba activo antes
					if node.has_meta("visibilidad_previa_dialogo"):
						node.visible = node.get_meta("visibilidad_previa_dialogo")

	# Revisamos también si hay ventanas de diálogo tipo Control sueltas por ahí
	elif node is Control:
		var nombre_c = node.name.to_lower()
		if "balloon" in nombre_c or "dialogue" in nombre_c:
			print("  -> Encontrado Control de Diálogo: '", node.name, "'. Cambiando visible a: ", not menu_abierto)
			if menu_abierto:
				# Lo mismo para nodos de diálogo tipo Control sueltos
				node.set_meta("visibilidad_previa_dialogo", node.visible)
				node.visible = false
			else:
				if node.has_meta("visibilidad_previa_dialogo"):
					node.visible = node.get_meta("visibilidad_previa_dialogo")

	# Esto tiene que ejecutarse SIEMPRE, para que no se atasque en ningún nodo
	for child in node.get_children():
		gestionar_visibilidad_dialogos(child, menu_abierto)

func activar_espera_menu() -> void:
	esperando_cierre_de_menu = true
