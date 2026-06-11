extends Node2D
#dialogo que se usa en esta escena
@onready var dialogo = preload ("res://dialogos/escenarios/inicio.dialogue")

# contador de los objetos interactuados para continuar la escena
#var contador = 0
var bloqueado = true
var cursor = preload("res://arte/cursores/cursor.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SaveGame.set_escena("res://escenas/inicio.tscn")
	Controlador.modo = "investigacion"
	Input.set_custom_mouse_cursor(cursor, Input.CURSOR_ARROW)
	MenuManager.cerrar_espera_menu.connect(cierra_cuaderno)
	# personajes que salen en la escena
	CharacterManager.register("detective", $detective)
	CharacterManager.register("duenyo", $duenyo)
	CharacterManager.register("fortachon", $fortachon)
	# dialogo inicial
	if SaveGame.game_data["contador_objetos_inicio"] > 0: 
		bloqueado = false
		return
	DialogueManager.show_dialogue_balloon(dialogo, "inicio1")

# funcion para hacer un personaje visible y reproducir su animación cuando habla
func show_character(name: String, anim: String = "default") -> void:
	CharacterManager.show_character(name, anim)

func hide_character(id: String) -> void:
	CharacterManager.hide_character(id)

# funcion para cuando se clica un objeto interactuable
func on_clicked_object(type, id):
	if bloqueado:
		return
	# si es la 1ª vez que se clica el objeto se aumenta el contador y se guarda como obj clicado
	if !SaveGame.game_data_has(type, id):
		SaveGame.game_data["contador_objetos_inicio"] += 1
		SaveGame.game_data_add(type, id)
	# cuando se clica uno de los objetos interactuables se reproduce su dialogo correspondiente
	show_character("detective", "default_frio")
	DialogueManager.show_dialogue_balloon(dialogo, id)

# cuando se termina un dialogo de objeto interactuable se comprueba si ya se han investigado todos
# los objetos para seguir con la historia
func terminar_exploracion() -> void:
	if SaveGame.game_data["contador_objetos_inicio"] == 5:
		Controlador.guardado = false
		DialogueManager.show_dialogue_balloon(dialogo, "inicio2")

#funcio para desbloquear los dialogos de los objetos al terminar el primer dialogo
func dialogo_inicial_terminado() -> void:
	Controlador.guardado = true
	bloqueado = false

func esperando_cuaderno() -> void:
	#empezamos a precargar la escena siguiente
	ResourceLoader.load_threaded_request("res://escenas/carpa_ini.tscn")
	bloqueado = true
	SaveGame.game_data_add("perfiles", "protagonista")
	SaveGame.game_data_add("perfiles", "detective")
	SaveGame.game_data_add("perfiles", "duenyo")
	SaveGame.game_data_add("perfiles", "fortachon")
	SaveGame.game_data_add("lugares", "exterior")
	$placeHolder.visible = true
	MenuManager.activar_espera_menu()

#Para quitar el cartel de aviso
func _input(event) -> void:
	if event.is_action_pressed("menu"):
		$placeHolder.visible = false

func cierra_cuaderno() -> void:
	DialogueManager.show_dialogue_balloon(dialogo, "inicio3")

func fin_escena() -> void:
	Controlador.cambio_escena_precargada("res://escenas/carpa_ini.tscn")
