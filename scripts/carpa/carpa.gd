extends Node2D
@onready var dialogo = load ("res://dialogos/escenarios/carpa.dialogue")
@onready var presentacion = $presentacion
@onready var descubrimiento = $descubrimiento

var characters = {}
var active_characters = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	presentacion.visible = false
	descubrimiento.visible = false
	$espada.visible = false
	$pantalla_negra.visible = false
	characters["detective"] = $detective
	characters["duenyo"] = $duenyo
	characters["maga"] = $maga
	characters["payasa"] = $payasa
	characters["trapecista"] = $trapecista
	characters["fortachon"] = $fortachon
	for c in characters.values():
		c.visibility(false)
	DialogueManager.show_dialogue_balloon(dialogo, "carpa1")

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

func espada_visibility(valor) -> void:
	$espada.visible = valor

func pantalla_negra(valor) -> void:
	$pantalla_negra.visible = valor

func play(obj, anim) -> void:
	await Controlador.fade_out()
	obj.visible = true
	await Controlador.fade_in()
	obj.play(anim)
	await obj.animation_finished
	await Controlador.fade_out()
	obj.visible = false
	await Controlador.fade_in()

func despues_descubrimiento() -> void:
	$pantalla_negra.visible = false
	DialogueManager.show_dialogue_balloon(dialogo, "carpa2")
