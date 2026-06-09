extends Node2D

var id_personaje_recibido: String = ""
var textura_fondo_recibida: Texture2D = null
var dialogo
var personaje_dialogo
var cursor_hand = preload("res://arte/cursores/pointer.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Controlador.modo = "puzzle"
	Input.set_custom_mouse_cursor(cursor_hand, Input.CURSOR_ARROW)
	_actualizar_pantalla()

func configurar_escena_interaccion(id: String, fondo: Texture2D) -> void:
	id_personaje_recibido = id
	textura_fondo_recibida = fondo
	
	if is_node_ready():
		_actualizar_pantalla()

func _actualizar_pantalla() -> void:
	dialogo = DataBase.dialogos["dialogo"]
	
	# 1. Actualizar el Fondo
	if textura_fondo_recibida != null:
		$fondo.texture = textura_fondo_recibida
	
	# 2. Actualizar el Personaje
	if id_personaje_recibido != "":
		var sprite = $personaje
		
		if sprite.sprite_frames.has_animation(id_personaje_recibido):
			sprite.play(id_personaje_recibido)
		else:
			print("Advertencia: No existe la animación: ", id_personaje_recibido)
	personaje_dialogo = DataBase.get_dialogo(id_personaje_recibido)
	#botones
	$cuaderno/dialogo1.text = personaje_dialogo["dialogos"]["dialogo1"]["nombre"]
	$cuaderno/dialogo2.text = personaje_dialogo["dialogos"]["dialogo2"]["nombre"]
	$cuaderno/dialogo3.text = personaje_dialogo["dialogos"]["dialogo3"]["nombre"]

func _on_dialogo_1_pressed() -> void:
	var nombre_dialogo = personaje_dialogo["dialogos"]["dialogo1"]["dialogo"]
	DialogueManager.show_dialogue_balloon(dialogo, nombre_dialogo)

func _on_dialogo_2_pressed() -> void:
	var nombre_dialogo = personaje_dialogo["dialogos"]["dialogo2"]["dialogo"]
	DialogueManager.show_dialogue_balloon(dialogo, nombre_dialogo)

func _on_dialogo_3_pressed() -> void:
	var nombre_dialogo = personaje_dialogo["dialogos"]["dialogo3"]["dialogo"]
	DialogueManager.show_dialogue_balloon(dialogo, nombre_dialogo)


func _on_salir_pressed() -> void:
	print("Escena: ", Controlador.escena)
	if Controlador.escena != null:
		# Recuperamos la escena guardada del Controlador
		var mapa_original = Controlador.escena
		
		# La volvemos a meter al árbol de juego
		get_tree().root.add_child(mapa_original)
		get_tree().current_scene = mapa_original
		
		# Limpiamos la variable global
		Controlador.escena = null
		
		# Destruimos la escena de interacción porque ya no la necesitamos
		queue_free()
