extends CanvasLayer

@onready var fade_rect := ColorRect.new()
var tween: Tween
var modo_actual: String = "investigacion"
var tutorial = false
var escena_investigacion_guardada = null
var cargando_partida: bool = false

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

func cambio_escena(escena) -> void:
	print("Se pasa a la escena asignada")
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
	SaveGame.load_game()
	print(SaveGame.game_data)
	var escena_guardada = SaveGame.game_data["escena"]
	
	if escena_guardada != null:
		cargando_partida = true 
		
		await fade_out(0.5)
		await get_tree().change_scene_to_file(escena_guardada)
		
		# Forzamos un par de frames de espera para que la escena ejecute su _ready()
		# y registre los personajes en el CharacterManager antes de invocar el diálogo.
		await get_tree().process_frame
		await get_tree().process_frame
		
		var dialogues_ruta = SaveGame.game_data["dialogo_activo"]
		var linea_id = SaveGame.game_data["dialogo_linea_id"]
		
		if dialogues_ruta != "" and linea_id != "":
			var resource = load(dialogues_ruta)
			
			# Hacemos aparecer a los personajes base según la escena
			if escena_guardada == "res://escenas/inicio.tscn":
				if CharacterManager.characters.has("detective"):
					CharacterManager.show_character("detective", "default_frio")
			elif escena_guardada == "res://escenas/carpa_ini.tscn":
				if CharacterManager.characters.has("duenyo"):
					CharacterManager.show_character("duenyo", "default")
			
			# Mostramos el globo directamente en la línea guardada
			DialogueManager.show_dialogue_balloon(resource, linea_id)
		
		await fade_in(0.5)
		cargando_partida = false
	else:
		print("No hay escena guardada en el archivo")
