# Por revisar
extends Node

var menu_scene = preload("res://escenas/menu.tscn")
var menu_instance

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	menu_instance = menu_scene.instantiate()
	get_tree().root.call_deferred("add_child", menu_instance)
	menu_instance.visible = false

	# detectar nuevos nodos añadidos
	get_tree().node_added.connect(_on_node_added)

func _on_node_added(node):
	if node is CanvasLayer:
		if "dialog" in node.name.to_lower() or "balloon" in node.name.to_lower():
			node.add_to_group("dialogue_ui")

func _input(event):
	if event.is_action_pressed("menu"):
		toggle_menu()

func toggle_menu():
	var abrir = !menu_instance.visible
	
	if not abrir:
		menu_instance.reset_tab_state()
	
	menu_instance.visible = abrir
	get_tree().paused = abrir

	if abrir and menu_instance.current_tab == null:
		menu_instance._init_first_tab()

	for node in get_tree().root.get_children():
		ocultar_dialogue_layers(node, abrir)

func ocultar_dialogue_layers(node, abrir):
	if node is CanvasLayer:
		# ocultamos cualquier CanvasLayer que no sea el menú
		if node != menu_instance:
			node.visible = not abrir

	for child in node.get_children():
		ocultar_dialogue_layers(child, abrir)

func ocultar_canvas_dialogo(node, abrir):
	if node is CanvasLayer:
		# DialogueManager suele poner el balloon dentro de CanvasLayer
		if "dialog" in node.name.to_lower() or "balloon" in node.name.to_lower():
			node.visible = not abrir

	for child in node.get_children():
		ocultar_canvas_dialogo(child, abrir)

func ocultar_dialogo_recursivo(node, abrir):
	# Si es CanvasLayer (el diálogo lo es casi seguro)
	if node is CanvasLayer:
		# heurística: ocultamos si parece UI de diálogo
		# (DialogueManager normalmente tiene nombre o hijos típicos)
		if "dialog" in node.name.to_lower() or node.get_child_count() > 0:
			node.visible = !abrir

	for child in node.get_children():
		ocultar_dialogo_recursivo(child, abrir)
