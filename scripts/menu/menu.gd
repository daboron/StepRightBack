# Por revisar
extends CanvasLayer
@onready var protagonista = $protagonista
@onready var tabs = $pestanyas.get_children()
@onready var pistas = $cuaderno/inventario/Pistas
@onready var perfiles = $cuaderno/inventario/Perfiles
@onready var lugares = $cuaderno/inventario/Lugares
@onready var selector_resolucion = $cuaderno/resolucion
@onready var selector_modo = $cuaderno/modo_pantalla
const item_ui = preload("res://escenas/ui/item_ui.tscn")
var current_tab = null
var tab_tweens = {}

const RESOLUCIONES = {
	0: Vector2i(1920, 1080),
	1: Vector2i(1600, 900),
	2: Vector2i(1280, 720),
	3: Vector2i(1024, 576)
}

func _ready() -> void:
	protagonista.visibility(true)
	protagonista.play_anim("default")
	$detalle.visible = false
	$bloqueador_clic.visible = false
	$cuaderno/guardar.visible = false
	$cuaderno/salir.visible = false

	_preparar_selector_modo()
	_preparar_selector_resolucion()

	for tab in tabs:
		tab.custom_minimum_size = Vector2(140, 48)
		tab.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		var button = tab.get_child(0)
		button.pressed.connect(_on_tab_pressed.bind(tab))

func _preparar_selector_modo() -> void:
	selector_modo.clear()
	selector_modo.add_item("Ventana", 0)
	selector_modo.add_item("Pantalla Completa", 1)
	
	# Detectar cómo inicia el juego para poner la opción correcta
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN or DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		selector_modo.selected = 1
	else:
		selector_modo.selected = 0
		
	if not selector_modo.item_selected.is_connected(_on_modo_seleccionado):
		selector_modo.item_selected.connect(_on_modo_seleccionado)
	selector_modo.visible = false

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
	
	# Conecta la señal nativa del OptionButton a nuestra función
	selector_resolucion.item_selected.connect(_on_resolucion_seleccionada)
	selector_resolucion.visible = false # Oculto al inicio

# Cambia el tamaño de ventana cuando el jugador elige una opción
func _on_resolucion_seleccionada(index: int) -> void:
	if RESOLUCIONES.has(index):
		var nueva_res = RESOLUCIONES[index]
		DisplayServer.window_set_size(nueva_res)
		
		# Centrar la ventana automáticamente en el monitor
		var centro = DisplayServer.screen_get_position() + (DisplayServer.screen_get_size() / 2)
		DisplayServer.window_set_position(centro - (nueva_res / 2))

func _init_first_tab() -> void:
	await get_tree().process_frame
	await get_tree().process_frame  # Doble frame para asegurar layout
	select_tab(tabs[0])
	select_menu(tabs[0])
	await get_tree().process_frame
	tabs[0].get_child(0).queue_redraw()

func _on_tab_pressed(tab):
	await get_tree().process_frame
	#print("Tab pulsado: ", tab.name)
	#Solo animacion de los botones
	select_tab(tab)
	#Mostrar el menu adecuado
	select_menu(tab)

func select_tab(selected_tab):
	#crear_inventario_prueba() #Solo para prueba
	#print("Seleccionando: ", selected_tab.name if selected_tab else "NULL")
	if selected_tab != current_tab:
		current_tab = selected_tab
		$pestanyas.queue_sort()
		for tab in tabs:
			if tab in tab_tweens and is_instance_valid(tab_tweens[tab]):
				tab_tweens[tab].kill()
			var button = tab.get_child(0)
			var is_selected = tab == selected_tab
			
			#Para la animacion
			var tween = create_tween()
			tab_tweens[tab] = tween

			# Escala los botones, sobresaliendo el clicado
			if is_selected:
				button.z_index = 10
				tween.tween_property(button, "scale", Vector2(1.16, 1.08), 0.15)
			else:
				button.z_index = 0
				tween.tween_property(button, "scale", Vector2(1.0, 1.0), 0.15)

#Seleccion de los distintos apartados del menu
func select_menu(selected_menu):
	var log = DialogueLog.get_log()
	var text = $cuaderno/log
	text.clear()
	$cuaderno/salir.visible = false
	$cuaderno/guardar.visible = false
	$cuaderno/inventario.visible = false
	pistas.visible = false
	perfiles.visible = false
	lugares.visible = false
	selector_resolucion.visible = false
	$cuaderno/resolucion_text.visible = false
	selector_modo.visible = false
	$cuaderno/modo_pantalla_text.visible = false
	match selected_menu.name:
		"PanelDialogos":
			for entry in log:
				if entry["character"] != "":
					text.append_text(" [font_size=26][color=#3A281A][b]%s[/b][/color][/font_size] [font_size=30][color=#3A281A]%s[/color][/font_size]\n" % [entry["character"], entry["text"]])
				else:
					text.append_text("[color=#7A1E1E][font_size=28][b]%s %s[/b][/font_size][/color]\n" % [entry["character"], entry["text"]])
			text.scroll_to_line(text.get_line_count())
		"PanelPistas":
			$cuaderno/inventario.visible = true
			pistas.visible = true
			for child in pistas.get_children():
				child.queue_free()
			for objeto in SaveGame.game_data["objetos"]:
				var inventory_item = item_ui.instantiate()
				var fase = SaveGame.game_data["objetos"].get(objeto, 1)
				var datos =  DataBase.get_perfil(objeto, fase)
				inventory_item.get_node("ColorRect/TextureRect").texture = datos["imagen"]
				inventory_item.get_node("Label").text = datos["nombre"]
				inventory_item.datos_item = datos
				inventory_item.item_pressed.connect(mostrar_detalle)
				pistas.add_child(inventory_item)
		"PanelPerfiles":
			$cuaderno/inventario.visible = true
			perfiles.visible = true
			for child in perfiles.get_children():
				child.queue_free()
			for perfil in SaveGame.game_data["perfiles"]:
				var inventory_item = item_ui.instantiate()
				var fase = SaveGame.game_data["perfiles"].get(perfil, 1)
				var datos =  DataBase.get_perfil(perfil, fase)
				inventory_item.get_node("ColorRect/TextureRect").texture = datos["imagen"]
				inventory_item.get_node("Label").text = datos["nombre"]
				inventory_item.datos_item = datos
				inventory_item.item_pressed.connect(mostrar_detalle)
				perfiles.add_child(inventory_item)
		"PanelLugares":
			$cuaderno/inventario.visible = true
			lugares.visible = true
			for child in lugares.get_children():
				child.queue_free()
			for lugar in SaveGame.game_data["lugares"]:
				var inventory_item = item_ui.instantiate()
				var fase = SaveGame.game_data["lugares"].get(lugar, 1)
				var datos =  DataBase.get_lugar(lugar, fase)
				inventory_item.get_node("ColorRect/TextureRect").texture = datos["imagen"]
				inventory_item.get_node("Label").text = datos["nombre"]
				inventory_item.datos_item = datos
				inventory_item.item_pressed.connect(mostrar_detalle)
				lugares.add_child(inventory_item)
		"PanelAjustes":
			selector_resolucion.visible = true
			$cuaderno/resolucion_text.visible = true
			selector_modo.visible = true
			$cuaderno/modo_pantalla_text.visible = true
			if Controlador.guardado: 
				$cuaderno/guardar.visible = true
				$cuaderno/salir.visible = true
		"PanelNotas":
			text.append_text("[color=#000000][font_size=40][b]%s[/b][/font_size][/color]\n" % ["Esta opción no está disponible por el momento"])

func reset_tab_state() -> void:
	current_tab = null

func abrir():
	visible = true
func cerrar():
	visible = false

func mostrar_detalle(datos):
	$detalle.visible = true
	$detalle.z_index = 100
	$bloqueador_clic.visible = true
	#$detalle.move_to_front()
	#$detalle.mouse_filter = Control.MOUSE_FILTER_STOP
	#$detalle.modulate = Color(1, 1, 1, 1)

	$detalle/ColorRect/HBoxContainer/imagen.texture = datos["imagen"]
	$detalle/ColorRect/HBoxContainer/VBoxContainer/nombre.text = datos["nombre"]
	$detalle/ColorRect/HBoxContainer/VBoxContainer/informacion.text = datos["informacion"]

func _on_cerrar_pressed() -> void:
	$detalle.visible = false
	$bloqueador_clic.visible = false


func _on_guardar_pressed() -> void:
	SaveGame.save_game()

func _on_salir_pressed() -> void:
	SaveGame.save_game()
	cerrar()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://escenas/menu_inicio.tscn")
