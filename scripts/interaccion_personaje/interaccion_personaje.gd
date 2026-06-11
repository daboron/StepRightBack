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
	print("Entra a actualizarse")
	dialogo = DataBase.dialogos_personajes["dialogo"]

	if textura_fondo_recibida != null:
		$fondo.texture = textura_fondo_recibida
	
	if id_personaje_recibido != "":
		var sprite = $personaje
		if sprite.sprite_frames.has_animation(id_personaje_recibido):
			sprite.play(id_personaje_recibido)
		else:
			print("Advertencia: No existe la animación: ", id_personaje_recibido)
		# la maga es la unica que tiene puzzle en la demo
		comprobar_maga()
	personaje_dialogo = DataBase.get_dialogo(id_personaje_recibido)
	#botones
	$cuaderno/dialogo1.text = personaje_dialogo["dialogos"]["dialogo1"]["nombre"]
	$cuaderno/dialogo2.text = personaje_dialogo["dialogos"]["dialogo2"]["nombre"]
	$cuaderno/dialogo3.text = personaje_dialogo["dialogos"]["dialogo3"]["nombre"]

func _on_dialogo_1_pressed() -> void:
	var nombre_dialogo = personaje_dialogo["dialogos"]["dialogo1"]["dialogo"]
	DialogueManager.show_dialogue_balloon(dialogo, nombre_dialogo)
	var dialogo = id_personaje_recibido + "1"
	SaveGame.game_data_add("dialogos_vistos", dialogo)

func _on_dialogo_2_pressed() -> void:
	var nombre_dialogo = personaje_dialogo["dialogos"]["dialogo2"]["dialogo"]
	DialogueManager.show_dialogue_balloon(dialogo, nombre_dialogo)

func _on_dialogo_3_pressed() -> void:
	var nombre_dialogo = personaje_dialogo["dialogos"]["dialogo3"]["dialogo"]
	DialogueManager.show_dialogue_balloon(dialogo, nombre_dialogo)


func _on_salir_pressed() -> void:
	print("Escena: ", Controlador.escena)
	if Controlador.escena != null:
		var mapa_original = Controlador.escena
		get_tree().root.add_child(mapa_original)
		get_tree().current_scene = mapa_original
		Controlador.escena = null
		queue_free()


func _on_deduccion_1_pressed() -> void:
	var puzzle_scene = preload("res://escenas/cuaderno.tscn").instantiate()
	puzzle_scene.configurar("puzzle2")
	puzzle_scene.puzzle_terminado.connect(puzzle_terminado)
	add_child(puzzle_scene)
	move_child(puzzle_scene, get_child_count() - 1)

func puzzle_terminado(dialogo):
	print("se termina el puzzle")

#funcion para limitar las deducciones para la demo
func comprobar_maga():
	if id_personaje_recibido == "maga":
		$cuaderno/deduccion1.visible = true
		if SaveGame.game_data_has("objetos", "caja_magica") && SaveGame.game_data_has("objetos", "espada") && SaveGame.game_data_has("objetos", "guirnalda") && SaveGame.game_data_has("dialogos_vistos", "maga1"):
			$cuaderno/deduccion1.disabled = false
		else:
				$cuaderno/deduccion1.disabled = true
	else:
		$cuaderno/deduccion1.visible = false
