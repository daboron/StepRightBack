extends Node2D
#dialogo que se usa en esta escena
@onready var dialogo = load ("res://dialogos/escenarios/inicio.dialogue")

var characters := {}
var active_characters := []
# contador de los objetos interactuados para continuar la escena
var contador = 0

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





# funcion para comprobar que el log de dialogo funciona (borrar mas tarde)
func prueba_dialogolog() -> void:
	var log = DialogueLog.get_log()
	for entry in log:
		print(entry["character"], ":", entry["text"])
