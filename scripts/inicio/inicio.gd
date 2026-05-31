extends Node2D
#dialogo que se usa en esta escena
@onready var dialogo = load ("res://dialogos/escenarios/inicio.dialogue")

var characters = {}
var active_characters = []
# contador de los objetos interactuados para continuar la escena
var contador = 0
var bloqueado = true
var esperando = false
var boton_Esc = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SaveGame.load_game() # Por ahora que cargue la partida aquí
	# personajes que salen en la escena
	characters["detective"] = $detective
	characters["duenyo"] = $duenyo
	characters["fortachon"] = $fortachon
	for c in characters.values():
		c.visibility(false)
	# dialogo inicial
	DialogueManager.show_dialogue_balloon(dialogo, "inicio1")

# funcion para hacer un personaje visible y reproducir su animación cuando habla
func show_character(name: String, anim: String = "default") -> void:
	var char = characters[name]
	char.visibility(true)
	char.play_anim(anim)
	_set_active(name)

func _set_active(name: String):
	if !active_characters.has(name):
		active_characters.append(name)
	update_layout()
	# cuando los personajes estan colocados aplicamos focus en el que esta hablando
	if active_characters.size() > 1:
		for c in characters.values():
			c.unfocus()
	characters[name].focus()

# funcion para colocar los personajes en la posicion (x) correspondiente segun cuantos hay
func update_layout():
	if active_characters.size() == 1:
		var c = characters[active_characters[0]]
		c.set_base_position(Vector2(960, 540))
	elif active_characters.size() == 2:
		characters[active_characters[0]].set_base_position(Vector2(600, 540))
		characters[active_characters[1]].set_base_position(Vector2(1320, 540))

#ocultar al personaje que ya no esta en escena
func hide_character(name: String):
	characters[name].visibility(false)
	active_characters.erase(name)
	update_layout()

# funcion para cuando se clica un objeto interactuable
func _on_clicked_object(type, id):
	if bloqueado:
		return
	# si es la 1ª vez que se clica el objeto se aumenta el contador y se guarda como obj clicado
	if !SaveGame.game_data_has(type, id):
		contador += 1
		SaveGame.game_data_add(type, id)
	# cuando se clica uno de los objetos interactuables se reproduce su dialogo correspondiente
	characters["detective"].visibility(true)
	characters["detective"].play_anim("default_frio")
	DialogueManager.show_dialogue_balloon(dialogo, id)

# cuando se termina un dialogo de objeto interactuable se comprueba si ya se han investigado todos
# los objetos para seguir con la historia
func terminar_exploracion() -> void:
	if contador == 5:
		DialogueManager.show_dialogue_balloon(dialogo, "inicio2")

#funcio para desbloquear los dialogos de los objetos al terminar el primer dialogo
func dialogo_inicial_terminado() -> void:
	bloqueado = false

func esperando_cuaderno() -> void:
	esperando = true
	$placeHolder.visible = true

func _input(event) -> void:
	if event.is_action_pressed("menu") && esperando == true:
		if boton_Esc == false:
			print("Se abre el cuaderno")
			$placeHolder.visible = false
			boton_Esc = true
		#Aquí no se entra cuando se está en la escena del menu
		else: 
			print("Se cierra el cuaderno")
			DialogueManager.show_dialogue_balloon(dialogo, "inicio3")
			boton_Esc = false
			esperando = false

func cierra_cuaderno() -> void:
	if esperando == true && boton_Esc == true:
		DialogueManager.show_dialogue_balloon(dialogo, "inicio3")
		boton_Esc = false
		esperando = false

func fin_escena() -> void:
	Controlador.cambio_escena("carpa")
