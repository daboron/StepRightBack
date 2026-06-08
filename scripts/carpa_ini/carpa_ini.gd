extends Node2D
@onready var dialogo = preload ("res://dialogos/escenarios/carpa.dialogue")

@onready var video_presentacion = $presentacion
@onready var video_descubrimiento = $descubrimiento
@onready var fondo = $Fondo
@onready var fondo_caja = $Fondo_caja
@onready var fondo_despues = $Fondo_despues
var fondos = []
var cursor = preload("res://arte/cursores/cursor.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SaveGame.set_escena("res://escenas/carpa_ini.tscn")
	Controlador.modo_actual = "investigacion"
	Input.set_custom_mouse_cursor(cursor, Input.CURSOR_ARROW)
	#await Controlador.fade_in()
	CharacterManager.register("detective", $CanvasLayer/detective)
	CharacterManager.register("duenyo", $duenyo)
	CharacterManager.register("maga", $maga)
	CharacterManager.register("payasa", $payasa)
	CharacterManager.register("trapecista", $trapecista)
	CharacterManager.register("fortachon", $fortachon)
	fondos.append(fondo)
	fondos.append(fondo_caja)
	fondos.append(fondo_despues)
	if Controlador.cargando_partida:
		print("Carga de partida detectada. Control cedido al Controlador.")
		return 
	DialogueManager.show_dialogue_balloon(dialogo, "carpa1")
	call_deferred("cargar_videos")

func cargar_videos() -> void:
	video_presentacion.stream = load("res://arte/animaciones/otras/personajes_converted.ogv")
	video_descubrimiento.stream = load("res://arte/animaciones/otras/cadaver_converted.ogv")

# funcion para hacer un personaje visible y reproducir su animación cuando habla
func show_character(name: String, anim: String = "default") -> void:
	CharacterManager.show_character(name, anim)

func hide_character(id: String) -> void:
	CharacterManager.hide_character(id)

func espada_visibility(valor) -> void:
	$espada.visible = valor

func marca(valor) -> void:
	$marca_cuello.visible = valor

func equimosis(valor) -> void:
	$equimosis.visible = valor

func pantalla_negra(valor) -> void:
	$pantalla_negra.visible = valor

func despues_descubrimiento() -> void:
	$pantalla_negra.visible = false
	SaveGame.game_data_add("perfiles", "maga")
	SaveGame.game_data_add("perfiles", "payasa")
	SaveGame.game_data_add("perfiles", "trapecista")
	#SaveGame.game_data_add("perfiles", "duenyo", 2)
	DialogueManager.show_dialogue_balloon(dialogo, "carpa2")

func video(video) -> void:
	await Controlador.fade_out()
	video.visible = true
	await get_tree().process_frame
	Controlador.fade_in()
	video.play()
	await video.finished
	video.stream = null

func puzzle() -> void:
	Controlador.set_tutorial(true)
	var puzzle_scene = preload("res://escenas/cuaderno.tscn").instantiate()
	puzzle_scene.configurar("puzzle1")
	puzzle_scene.puzzle_terminado.connect(puzzle_terminado)
	add_child(puzzle_scene)
	move_child(puzzle_scene, get_child_count() - 1)

func cambiar_fondo(fondo) -> void:
	for item in fondos:
		item.visible = false
	fondo.visible = true

func puzzle_terminado(dialogo):
	#ResourceLoader.load_threaded_request("res://escenas/carpa.tscn")
	DialogueManager.show_dialogue_balloon(dialogo["dialogo"], dialogo["nombre_dialogo"])

func escena_terminada() -> void:
	Controlador.cambio_escena("res://escenas/carpa.tscn")
