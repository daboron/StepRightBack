extends CanvasLayer

# Para animacion de fundido a negro
@onready var fade_rect := ColorRect.new()
var tween: Tween

var modo: String = "investigacion"
var tutorial = false
var escena = null
var guardado = false
var modo_pantalla: int = 0
var resolucion_pantalla: int = 0
var dentro_juego = false

const RESOLUCIONES = {
	0: Vector2i(1920, 1080),
	1: Vector2i(1600, 900),
	2: Vector2i(1280, 720),
	3: Vector2i(1024, 576)
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#se crea un rectangulo negro que ocupa toda la pantalla
	fade_rect.color = Color(0, 0, 0, 1)
	fade_rect.modulate.a = 0.0
	fade_rect.visible = false
	fade_rect.anchor_left = 0
	fade_rect.anchor_top = 0
	fade_rect.anchor_right = 1
	fade_rect.anchor_bottom = 1
	add_child(fade_rect)
	
	var modo_inicial = DisplayServer.window_get_mode()
	if modo_inicial == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN or modo_inicial == DisplayServer.WINDOW_MODE_FULLSCREEN:
		modo_pantalla = 1
	else:
		modo_pantalla = 0
	var tamanyo_actual = DisplayServer.window_get_size()
	for index in RESOLUCIONES:
		if RESOLUCIONES[index] == tamanyo_actual:
			resolucion_pantalla = index
			break

func cambio_escena_precargada(escena) -> void:
	CharacterManager.clear()
	await fade_out(0.5)
	# para esperar la precarga de la escena
	var status = ResourceLoader.load_threaded_get_status(escena)
	while status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		await get_tree().process_frame
		status = ResourceLoader.load_threaded_get_status(escena)
	var packed_scene = ResourceLoader.load_threaded_get(escena)
	await get_tree().change_scene_to_packed(packed_scene)
	fade_in(0.5)

func cambio_escena(escena) -> void:
	CharacterManager.clear()
	await fade_out(0.5)
	await get_tree().change_scene_to_file(escena)
	fade_in(0.5)

func fade_out(t := 0.5) -> void:
	fade_rect.visible = true
	tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 1.0, t)
	await tween.finished

func fade_in(t := 0.5) -> void:
	tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 0.0, t)
	await tween.finished
	fade_rect.visible = false

func set_tutorial(estado) -> void:
	tutorial = estado

func cargar_partida_guardada() -> void:
	dentro_juego = true
	SaveGame.load_game()
	print(SaveGame.game_data)
	var escena_guardada = SaveGame.game_data["escena"]
	if escena_guardada != null:
		
		await fade_out(0.5)
		await get_tree().change_scene_to_file(escena_guardada)
		
		# Esperamos a que la escena cargue su _ready() y configure sus personajes automáticamente
		await get_tree().process_frame
		await get_tree().process_frame
		
		# --- AQUÍ ESTÁ EL CAMBIO DINÁMICO ---
		# En lugar de ifs abstractos, recorremos todos los personajes guardados
		# y si CharacterManager los reconoce, les aplica el estado guardado.
		var perfiles_guardados: Dictionary = SaveGame.game_data["perfiles"]
		for personaje in perfiles_guardados.keys():
			var estado = perfiles_guardados[personaje]
			
			if CharacterManager.personajes.has(personaje):
				if estado == "oculto":
					CharacterManager.hide_character(personaje) # O como lo maneje tu manager
				else:
					CharacterManager.show_character(personaje, estado)
		# ------------------------------------
		
		# Carga del diálogo posterior
		var dialogues_ruta = SaveGame.game_data["dialogo_activo"]
		var linea_id = SaveGame.game_data["dialogo_linea_id"]
		
		if dialogues_ruta != "" and linea_id != "":
			var resource = load(dialogues_ruta)
			DialogueManager.show_dialogue_balloon(resource, linea_id)
		
		await fade_in(0.5)
	else:
		print("No hay escena guardada en el archivo")


func cambiar_modo_pantalla(index: int) -> void:
	modo_pantalla = index
	if index == 0:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		cambiar_resolucion(resolucion_pantalla)
	elif index == 1:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

func cambiar_resolucion(index: int) -> void:
	resolucion_pantalla = index
	if RESOLUCIONES.has(index):
		var nueva_res = RESOLUCIONES[index]
		DisplayServer.window_set_size(nueva_res)
		var centro = DisplayServer.screen_get_position() + (DisplayServer.screen_get_size() / 2)
		DisplayServer.window_set_position(centro - (nueva_res / 2))
