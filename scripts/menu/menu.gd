# Por revisar
extends CanvasLayer
@onready var protagonista = $protagonista
@onready var tabs = $pestanyas.get_children()
var current_tab = null
# Guarda el tween activo de cada pestaña
var tab_tweens = {}  

func _ready() -> void:
	protagonista.visibility(true)
	protagonista.play_anim("default")

	for tab in tabs:
		tab.custom_minimum_size = Vector2(140, 48)
		tab.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		var button = tab.get_child(0)
		button.pressed.connect(_on_tab_pressed.bind(tab))

	#await get_tree().process_frame
	#select_tab(tabs[0])
	#select_menu(tabs[0])
	
	#await get_tree().process_frame
	#tabs[0].get_child(0).queue_redraw()

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

func select_menu(selected_menu):
	var log = DialogueLog.get_log()
	var text = $cuaderno/log
	text.clear()
	$salir.visible = false
	match selected_menu.name:
		"PanelDialogos":
			print("Dialgos")
			for entry in log:
				if entry["character"] != "":
					text.append_text("[color=#000000][font_size=20][b]%s[/b] %s[/font_size][/color]\n" % [entry["character"], entry["text"]])
				else:
					text.append_text("[color=#3E8E41][font_size=20][b]%s %s[/b][/font_size][/color]\n" % [entry["character"], entry["text"]])
		"PanelObjetos":
			print("Objetos")
		"PanelPerfiles":
			print("Perfiles")
		"PanelLugares":
			print("Lugares")
		"PanelAjustes":
			print("Ajustes")
			$salir.visible = true
		"PanelNotas":
			print("Notas")
			text.append_text("[color=#000000][font_size=40][b]%s[/b][/font_size][/color]\n" % ["Esta opción no está disponible por el momento"])

func reset_tab_state() -> void:
	current_tab = null

func abrir():
	visible = true
func cerrar():
	visible = false
