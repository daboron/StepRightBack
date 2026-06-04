# Por revisar
extends CanvasLayer
@onready var protagonista = $protagonista
@onready var tabs = $pestanyas.get_children()
@onready var objetos = $cuaderno/inventario/Objetos
@onready var perfiles = $cuaderno/inventario/Perfiles
@onready var lugares = $cuaderno/inventario/Lugares
const item_ui = preload("res://escenas/ui/item_ui.tscn")
var current_tab = null
var tab_tweens = {}  

func _ready() -> void:
	protagonista.visibility(true)
	protagonista.play_anim("default")
	$detalle.visible = false
	$bloqueador_clic.visible = false

	for tab in tabs:
		tab.custom_minimum_size = Vector2(140, 48)
		tab.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		var button = tab.get_child(0)
		button.pressed.connect(_on_tab_pressed.bind(tab))


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
	$cuaderno/inventario.visible = false
	objetos.visible = false
	perfiles.visible = false
	lugares.visible = false
	match selected_menu.name:
		"PanelDialogos":
			print("Dialgos")
			for entry in log:
				if entry["character"] != "":
					text.append_text("[color=#000000][font_size=20][b]%s[/b] %s[/font_size][/color]\n" % [entry["character"], entry["text"]])
				else:
					text.append_text("[color=#3E8E41][font_size=20][b]%s %s[/b][/font_size][/color]\n" % [entry["character"], entry["text"]])
			text.scroll_to_line(text.get_line_count())
		"PanelObjetos":
			print("Objetos")
			$cuaderno/inventario.visible = true
			objetos.visible = true
			for child in objetos.get_children():
				child.queue_free()
			for objeto in SaveGame.game_data["objetos"]:
				var inventory_item = item_ui.instantiate()
				var fase = SaveGame.game_data["objetos"].get(objeto, 1)
				var datos =  DataBase.get_perfil(objeto, fase)
				inventory_item.get_node("ColorRect/TextureRect").texture = datos["imagen"]
				inventory_item.get_node("Label").text = datos["nombre"]
				inventory_item.datos_item = datos
				inventory_item.item_pressed.connect(mostrar_detalle)
				objetos.add_child(inventory_item)
		"PanelPerfiles":
			print("Perfiles")
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
			print("Lugares")
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
			print("Ajustes")
			$cuaderno/salir.visible = true
		"PanelNotas":
			print("Notas")
			text.append_text("[color=#000000][font_size=40][b]%s[/b][/font_size][/color]\n" % ["Esta opción no está disponible por el momento"])

func reset_tab_state() -> void:
	current_tab = null

func abrir():
	visible = true
func cerrar():
	visible = false

func _on_salir_pressed() -> void:
	SaveGame.save_game()
	get_tree().quit()

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
