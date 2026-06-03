extends Node2D
@onready var dialogo = preload ("res://dialogos/escenarios/carpa.dialogue")

@onready var video_presentacion = $presentacion
@onready var video_descubrimiento = $descubrimiento

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await Controlador.fade_in()
	CharacterManager.register("detective", $detective)
	CharacterManager.register("duenyo", $duenyo)
	CharacterManager.register("maga", $maga)
	CharacterManager.register("payasa", $payasa)
	CharacterManager.register("trapecista", $trapecista)
	CharacterManager.register("fortachon", $fortachon)
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

func pantalla_negra(valor) -> void:
	$pantalla_negra.visible = valor

func despues_descubrimiento() -> void:
	$pantalla_negra.visible = false
	SaveGame.game_data_add("perfiles", "maga")
	SaveGame.game_data_add("perfiles", "payasa")
	SaveGame.game_data_add("perfiles", "trapecista")
	SaveGame.game_data_add("perfiles", "duenyo", 2)
	DialogueManager.show_dialogue_balloon(dialogo, "carpa2")

func video(video) -> void:
	await Controlador.fade_out()
	video.visible = true
	await get_tree().process_frame
	Controlador.fade_in()
	video.play()
	await video.finished
	video.stream = null
