# Por revisar
extends CanvasLayer
@onready var protagonista = $protagonista
@onready var tabs = $pestañas.get_children()
var current_tab = null
var tab_tweens = {}  # Guarda el tween activo de cada pestaña

func _ready() -> void:
	protagonista.visibility(true)
	protagonista.play_anim("default")

	for tab in tabs:
		tab.custom_minimum_size = Vector2(140, 48)
		tab.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		var button = tab.get_child(0)
		button.pressed.connect(_on_tab_pressed.bind(tab))

	await get_tree().process_frame
	select_tab(tabs[0])

func _on_tab_pressed(tab):
	await get_tree().process_frame
	print("Tab pulsado: ", tab.name)
	select_tab(tab)

func select_tab(selected_tab):
	print("Seleccionando: ", selected_tab.name if selected_tab else "NULL")

	if selected_tab == current_tab:
		return

	current_tab = selected_tab

	$pestañas.queue_sort()

	for tab in tabs:
		if tab in tab_tweens and is_instance_valid(tab_tweens[tab]):
			tab_tweens[tab].kill()

		var button = tab.get_child(0)
		var is_selected = tab == selected_tab

		var tween = create_tween()
		tab_tweens[tab] = tween

		# SOLO escala (evita layout conflictivo)
		if is_selected:
			button.z_index = 10
			tween.tween_property(button, "scale", Vector2(1.16, 1.08), 0.15)
		else:
			button.z_index = 0
			tween.tween_property(button, "scale", Vector2(1.0, 1.0), 0.15)

func abrir():
	visible = true
func cerrar():
	visible = false
