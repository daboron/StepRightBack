extends Node2D

@onready var fondo_interaccion = preload("res://arte/fondos/SET_Escenario.png")
var cursor = preload("res://arte/cursores/cursor.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SaveGame.set_escena("res://escenas/carpa.tscn")
	Controlador.guardado = true
	await Controlador.fade_in()
	Controlador.modo_actual = "investigacion"
	Input.set_custom_mouse_cursor(cursor, Input.CURSOR_ARROW)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_clicked_object(type, id):
	if !SaveGame.game_data_has(type, id):
		SaveGame.game_data_add(type, id)

# cuando clicamos personaje nos vamos a su escena
func on_clicked_character(character_node: InteractableCharacter):
	if character_node.escena_cuaderno:
		var nueva_escena = character_node.escena_cuaderno.instantiate()
		nueva_escena.configurar_escena_interaccion(character_node.id, fondo_interaccion)
		var arbol_actual = get_tree()
		Controlador.escena_investigacion_guardada = self
		if get_parent():
			get_parent().remove_child(self)
		arbol_actual.root.add_child(nueva_escena)
		arbol_actual.current_scene = nueva_escena
